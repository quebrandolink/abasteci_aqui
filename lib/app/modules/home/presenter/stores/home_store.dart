import 'package:flutter_triple/flutter_triple.dart';
import 'package:fuel_manager/app/modules/home/domain/entities/fuel_entity.dart';
import 'package:fuel_manager/app/modules/home/domain/usecases/fuel_usecase.dart';
import 'package:fuel_manager/app/shared/exceptions/fuel_exception.dart';

class HomeStore extends NotifierStore<FuelException, List<FuelEntity>> {
  final FuelUsecase usecase;
  HomeStore(this.usecase) : super([]);

  Future<void> getList() async {
    setLoading(true);

    final results = await usecase();

    results.fold(setError, update);

    setLoading(false);
  }

  Future<void> delete(FuelEntity model) async {
    await usecase.delete(model);
    getList();
  }
}
