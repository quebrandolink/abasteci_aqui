// ignore_for_file: must_be_immutable, prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fuel_manager/app/modules/home/domain/entities/fuel_entity.dart';
import 'package:fuel_manager/app/shared/exceptions/fuel_exception.dart';
import 'package:fuel_manager/app/shared/helpers/snackbar_menager.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../auth/presenters/stores/auth_store.dart';
import '../../domain/usecases/fuel_usecase.dart';

class FuelStore extends NotifierStore<FuelException, FuelEntity> {
  final _authStore = Modular.get<AuthStore>();
  FuelStore(this.usecase) : super(FuelEntity(latitude: 0, longitude: 0));
  final FuelUsecase usecase;
  late GoogleMapController mapController;
  late TextEditingController kmController;
  late TextEditingController vehicleController;
  late TextEditingController literController;
  late TextEditingController valueLiterController;
  GlobalKey<ScaffoldState> scaffoldKeyFuelStore = GlobalKey<ScaffoldState>();

  FuelEntity _fuelEntity = FuelEntity(
    latitude: 0,
    longitude: 0,
  );

  setVehicle(String vehicle) {
    vehicleController.text = vehicle;
  }

  void dispose() {
    mapController.dispose();
    kmController.dispose();
    vehicleController.dispose();
    literController.dispose();
    valueLiterController.dispose();
  }

  initState({String? lastVehicle, FuelEntity? entity}) {
    kmController = TextEditingController();
    vehicleController = TextEditingController();
    literController = TextEditingController();
    valueLiterController = TextEditingController();
    getPosition(entity);
    if (lastVehicle != null && lastVehicle != "null") {
      vehicleController.text = lastVehicle;
    } else {
      vehicleController.clear();
    }
    kmController.clear();
    literController.clear();
    valueLiterController.clear();
  }

  Future<void> insert(FuelEntity model, BuildContext context) async {
    if (kmController.text.trim().isEmpty) {
      SnackbarMenager().showError(context, "Insira a quilometragem do veículo.",
          duration: const Duration(seconds: 5));
      return;
    } else {
      model.km =
          int.parse(kmController.text.replaceAll(".", "").replaceAll(",", ""));
    }
    if (vehicleController.text.trim().isEmpty) {
      SnackbarMenager().showError(context, "Insira a placa do veículo.",
          duration: const Duration(seconds: 5));
      return;
    } else {
      model.vehicle = vehicleController.text;
    }
    model.liter = literController.text.isNotEmpty
        ? double.parse(literController.text.replaceAll(",", "."))
        : 0.0;
    model.valueLiter = valueLiterController.text.isNotEmpty
        ? double.parse(valueLiterController.text.replaceAll(",", "."))
        : 0.0;

    if (_authStore.user == null) {
      SnackbarMenager().showError(
          context, "Erro ao obter os dados do usuário, faça login novamente.",
          duration: const Duration(seconds: 5));
      return;
    } else {
      model.userId = _authStore.user!.email;
    }
    final result = await usecase.insert(model);

    result.fold((error) {
      SnackbarMenager().showError(context, error.message,
          duration: const Duration(seconds: 3));
    }, (isSaved) {
      if (isSaved) {
        SnackbarMenager().showSuccess(scaffoldKeyFuelStore.currentContext!,
            "Abastecimento salvo com sucesso.",
            duration: const Duration(seconds: 3));
        Modular.to.pop(model);
      } else {
        SnackbarMenager().showError(
            context, "Não foi possível salvar, Tente novamente.",
            duration: const Duration(seconds: 3));
      }
    });
  }

  Future<void> delete(FuelEntity model, BuildContext context) async {
    setLoading(true);
    final result = await usecase.delete(model);

    result.fold((error) {
      SnackbarMenager().showError(context, error.message,
          duration: const Duration(seconds: 5));
    }, (isSaved) {
      if (isSaved) {
        SnackbarMenager().showSuccess(scaffoldKeyFuelStore.currentContext!,
            "Abastecimento excluido com sucesso.",
            duration: const Duration(seconds: 5));
        Modular.to.pop(true);
      } else {
        SnackbarMenager().showError(
            context, "Não foi possível excluir, Tente novamente.",
            duration: const Duration(seconds: 5));
      }
    });
    setLoading(false);
  }

  void onMapCreated(
      GoogleMapController gmc, Brightness brightness, FuelEntity? model) async {
    mapController = gmc;
    if (brightness == Brightness.dark) {
      await _getJsonFile("assets/json/night.json")
          .then(mapController.setMapStyle);
    }
    getPosition(model);
  }

  Future<String> _getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  Future<void> getPosition(FuelEntity? model) async {
    setLoading(false);
    try {
      late LatLng latLng;
      _fuelEntity = state;

      if (model != null) {
        if (model.latitude == null || model.longitude == null) {
          Position position = await _currentPosition();
          model.latitude = position.latitude;
          model.longitude = position.longitude;
        }
        if (model.address == null || model.address!.isEmpty) {
          final address = await _getAddress(model.latitude!, model.longitude!);
          model.address = address;
        }
        latLng = LatLng(model.latitude!, model.longitude!);
        _fuelEntity = model;
      } else {
        Position position = await _currentPosition();
        latLng = LatLng(position.latitude, position.longitude);
        final address = await _getAddress(latLng.latitude, latLng.longitude);
        _fuelEntity = FuelEntity(
          address: address,
          latitude: latLng.latitude,
          longitude: latLng.longitude,
          date: DateTime.now(),
        );
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: latLng, zoom: 17.0),
          ),
        );
      }

      if (kDebugMode) {
        print(_fuelEntity.toString());
      }

      update(_fuelEntity);
    } on FuelException catch (e) {
      setError(e);
    }
  }

/*
  Future<String> _getAddress(double latitude, double longitude) async {
    if (latitude == 0.0 || longitude == 0.0) {
      return "";
    }
    GBLatLng position = GBLatLng(lat: latitude, lng: longitude);
    GBData data = await GeocoderBuddy.findDetails(position).catchError((e, s) {
      if (kDebugMode) {
        print("error = $e");
        print(s);
        print("latitude:$latitude - longitude:$longitude");
      }
      throw AddressException("Erro ao buscar endereço novo.");
    });

    //TODO: olhar aqui depois;

    Address address = data.address;

    String result =
        "${address.road}, ${address.village}-${address.stateDistrict}";

    return result;
  }

*/
  Future<String> _getAddress(double latitude, double longitude) async {
    if (latitude == 0.0 || longitude == 0.0) {
      return "";
    }
    String mapsApiKey = const String.fromEnvironment("ANDROID_MAPS_APIKEY");
    GeoData data = await Geocoder2.getDataFromCoordinates(
            language: "pt-BR",
            latitude: latitude,
            longitude: longitude,
            googleMapApiKey: mapsApiKey)
        .catchError((e) => throw FuelException("Erro ao buscar endereço."));
    List<String> address = data.address.split(",");
    return "${address[0]},${address[1].replaceAll(" -", ",")},${address[2].replaceAll(" - ", "-")}";
  }

  Future<Position> _currentPosition() async {
    LocationPermission permission;

    bool isActive = await Geolocator.isLocationServiceEnabled();
    if (!isActive) {
      throw FuelException("Por favor, habilite a localização do smartphone.");
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw FuelException("Por favor, habilite a localização do smartphone.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw FuelException('Você precisa autorizar o acesso à localização');
    }

    return await Geolocator.getCurrentPosition();
  }
}
