// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';

import 'package:fuel_manager/app/modules/home/domain/entities/fuel_entity.dart';
import 'package:fuel_manager/app/modules/home/domain/repositories/fuel_repository.dart';
import 'package:fuel_manager/app/shared/exceptions/fuel_exception.dart';

abstract class FuelUsecase {
  Future<Either<FuelException, List<FuelEntity>>> call();
  Future<Either<FuelException, bool>> insert(FuelEntity model);
  Future<Either<FuelException, bool>> delete(FuelEntity model);
}

class FuelUsecaseImpl implements FuelUsecase {
  final FuelRepository repository;

  FuelUsecaseImpl(this.repository);

  @override
  Future<Either<FuelException, List<FuelEntity>>> call() async {
    return await repository.getFuelList();
  }

  @override
  Future<Either<FuelException, bool>> insert(FuelEntity model) async {
    if (model.latitude == 0 || model.longitude == 0) {
      return Left(FuelException(
          "Não foi possível obter a localização do abastecimento."));
    }
    return await repository.insert(model);
  }

  @override
  Future<Either<FuelException, bool>> delete(FuelEntity model) async {
    if (model.uid.isEmpty) {
      return Left(FuelException(
          "Não foi possível obter os dados do abastecimento para exclusão. Tente novamente."));
    }
    return await repository.delete(model);
  }
}
