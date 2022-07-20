// ignore_for_file: must_be_immutable

import 'package:flutter_triple/flutter_triple.dart';
import '../../domain/entities/fuel_entity.dart';
import '../../domain/usecases/fuel_usecase.dart';
import '../../../../shared/exceptions/fuel_exception.dart';

class HomeStore extends NotifierStore<FuelException, List<FuelEntity>> {
  final FuelUsecase usecase;
  HomeStore(this.usecase) : super([]);

  List<FuelEntity> listFuel = [];

  String? get lastVehicle => listFuel.first.vehicle;

  Future<void> getList() async {
    setLoading(true);
    final results = await usecase();
    results.fold((error) {
      setError(error);
    }, (results) {
      listFuel = results;
      update(listFuel);
    });
    setLoading(false);
  }
}
