// ignore_for_file: must_be_immutable, prefer_final_fields

import 'package:flutter/cupertino.dart';
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

import '../../domain/usecases/fuel_usecase.dart';

class FuelStore extends NotifierStore<FuelException, FuelEntity> {
  FuelStore(this.usecase) : super(FuelEntity(latitude: 0, longitude: 0));
  final FuelUsecase usecase;
  late GoogleMapController _mapController;
  TextEditingController kmController = TextEditingController();
  Set<Marker> markers = <Marker>{};

  get mapController => _mapController;

  FuelEntity _fuelEntity = FuelEntity(latitude: 0, longitude: 0);

  Future<void> insert(FuelEntity model, BuildContext context) async {
    if (kmController.text.trim().isEmpty) {
      SnackbarMenager().showError(context, "Insira a quilometragem do veículo.",
          duration: const Duration(seconds: 5));
      return;
    } else {
      model.km = int.parse(kmController.text);
    }

    model.userId = "12312312343543";
    final result = await usecase.insert(model);

    result.fold((error) {
      SnackbarMenager().showError(context, error.message,
          duration: const Duration(seconds: 5));
    }, (isSaved) {
      if (isSaved) {
        SnackbarMenager().showSuccess(
            context, "Abastecimento salvo com sucesso.",
            duration: const Duration(seconds: 5));
        Modular.to.pop();
      } else {
        SnackbarMenager().showError(
            context, "Não foi possível salvar, Tente novamente.",
            duration: const Duration(seconds: 5));
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
        SnackbarMenager().showSuccess(
            context, "Abastecimento excluido com sucesso.",
            duration: const Duration(seconds: 5));
        Modular.to.pop();
      } else {
        SnackbarMenager().showError(
            context, "Não foi possível excluir, Tente novamente.",
            duration: const Duration(seconds: 5));
      }
    });
    setLoading(false);
  }

  setMarker() async {
    print("set marker: ${_fuelEntity.toString()}");
    markers.add(
      Marker(
        markerId: MarkerId("${_fuelEntity.address}"),
        position: LatLng(_fuelEntity.latitude!, _fuelEntity.longitude!),
        // icon: await BitmapDescriptor.fromAssetImage(
        //   const ImageConfiguration(),
        //   'assets/images/fuel-marker.png',
        // ),
      ),
    );
  }

  void onMapCreated(
      GoogleMapController gmc, Brightness brightness, FuelEntity? model) async {
    _mapController = gmc;
    if (brightness == Brightness.dark) {
      getJsonFile("assets/json/night.json").then(_mapController.setMapStyle);
    }
    getPosition(model);
    setMarker();
  }

  Future<String> getJsonFile(String path) async {
    return await rootBundle.loadString(path);
  }

  Future<void> getPosition(FuelEntity? model) async {
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
          final address = await getAddress(model.latitude!, model.longitude!);
          model.address = address.address;
        }
        latLng = LatLng(model.latitude!, model.longitude!);
        _fuelEntity = model;
      } else {
        Position position = await _currentPosition();
        latLng = LatLng(position.latitude, position.longitude);
        final address = await getAddress(latLng.latitude, latLng.longitude);
        _fuelEntity = FuelEntity(
          address: address.address,
          latitude: latLng.latitude,
          longitude: latLng.longitude,
          date: DateTime.now(),
        );
        _mapController.animateCamera(
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
    } catch (e) {
      setError(FuelException(e.toString()));
    }
    setLoading(false);
  }

  Future<GeoData> getAddress(double latitude, double longitude) async {
    String mapsApiKey = const String.fromEnvironment("ANDROID_MAPS_APIKEY");
    GeoData data = await Geocoder2.getDataFromCoordinates(
        latitude: latitude, longitude: longitude, googleMapApiKey: mapsApiKey);

    return data;
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
