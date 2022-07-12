import '../../domain/entities/fuel_entity.dart';

abstract class FuelDatasource {
  Future<List<FuelEntity>> getFuelList();
  Future<bool> insert(FuelEntity model);
  Future<bool> delete(FuelEntity model);
}
