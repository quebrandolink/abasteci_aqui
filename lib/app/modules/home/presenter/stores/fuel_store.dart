// ignore_for_file: must_be_immutable, prefer_final_fields

import 'package:flutter/foundation.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fuel_manager/app/modules/home/domain/entities/fuel_entity.dart';
import 'package:fuel_manager/app/shared/exceptions/fuel_exception.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/usecases/fuel_usecase.dart';

class FuelStore extends NotifierStore<FuelException, FuelEntity> {
  FuelStore(this.usecase)
      : super(FuelEntity(latitude: -23.4906411, longitude: -51.1377816));
  final FuelUsecase usecase;
  late GoogleMapController _mapController;

  get mapController => _mapController;

  FuelEntity _fuelEntity =
      FuelEntity(latitude: -23.2906411, longitude: -51.1377816);

  Future<void> insert({FuelEntity? model}) async {
    await usecase.insert(_fuelEntity);
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

      if (kDebugMode) {
        print("${position.latitude}, ${position.longitude}");
      }
      _fuelEntity.date = DateTime.now();
      _fuelEntity.latitude = position.latitude;
      _fuelEntity.longitude = position.longitude;

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
