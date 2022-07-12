// ignore_for_file: must_be_immutable, prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fuel_manager/app/modules/home/domain/entities/fuel_entity.dart';
import 'package:fuel_manager/app/shared/exceptions/fuel_exception.dart';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/usecases/fuel_usecase.dart';

class FuelStore extends NotifierStore<FuelException, FuelEntity> {
  FuelStore(this.usecase) : super(FuelEntity(latitude: 0, longitude: 0));
  final FuelUsecase usecase;
  late GoogleMapController _mapController;

  get mapController => _mapController;

  FuelEntity _fuelEntity = FuelEntity(latitude: 0, longitude: 0);

  Future<void> insert(model) async {
    await usecase.insert(model);
  }

  Future<void> delete(FuelEntity model) async {
    await usecase.delete(model);
  }

  void onMapCreated(GoogleMapController gmc) async {
    _mapController = gmc;
    await getPosition();
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(_fuelEntity.latitude!, _fuelEntity.longitude!),
            zoom: 17.0),
      ),
    );
  }

  Future<void> getPosition() async {
    try {
      _fuelEntity = state;
      Position position = await _currentPosition();
      final address = await getAddress(position.latitude, position.longitude);
      _fuelEntity = FuelEntity(
        address: address.address,
        latitude: position.latitude,
        longitude: position.longitude,
        date: DateTime.now(),
      );

      if (kDebugMode) {
        print(_fuelEntity.toString());
      }

      update(_fuelEntity);
    } on FuelException catch (e) {
      setError(e);
    } catch (e) {
      setError(FuelException(e.toString()));
    } finally {
      setLoading(false);
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
