import 'package:dartz/dartz.dart';
import '../entities/fuel_entity.dart';

import '../../../../shared/exceptions/fuel_exception.dart';

abstract class FuelRepository {
  Future<Either<FuelException, List<FuelEntity>>> getFuelList();
  Future<Either<FuelException, bool>> insert(FuelEntity model);
  Future<Either<FuelException, bool>> delete(FuelEntity model);
}
