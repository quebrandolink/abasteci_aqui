// ignore_for_file: must_be_immutable

import 'package:flutter_triple/flutter_triple.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../domain/entities/fuel_entity.dart';
import '../../domain/usecases/fuel_usecase.dart';
import '../../../../shared/exceptions/fuel_exception.dart';

class HomeStore extends NotifierStore<FuelException, List<FuelEntity>> {
  final FuelUsecase usecase;
  HomeStore(this.usecase) : super([]);

  RefreshController refreshController =
      RefreshController(initialRefresh: false);

  List<FuelEntity> listFuel = [];

  String? get lastVehicle =>
      listFuel.isNotEmpty ? listFuel.first.vehicle : null;

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

  void onRefresh() async {
    getList();
    observer(
      onError: (error) => refreshController.loadFailed(),
      onState: (state) => state.isEmpty
          ? refreshController.loadNoData()
          : refreshController.loadComplete(),
    );
  }
}
