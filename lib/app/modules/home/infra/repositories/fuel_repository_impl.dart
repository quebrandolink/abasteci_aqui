// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:dartz/dartz.dart';
import 'package:fuel_manager/app/modules/home/domain/entities/fuel_entity.dart';
import 'package:fuel_manager/app/modules/home/domain/repositories/fuel_repository.dart';
import 'package:fuel_manager/app/modules/home/infra/datasources/fuel_datasource.dart';
import 'package:fuel_manager/app/shared/exceptions/fuel_exception.dart';

class FuelRepositoryImpl implements FuelRepository {
  FuelDatasource datasource;

  FuelRepositoryImpl(this.datasource);

  @override
  Future<Either<FuelException, List<FuelEntity>>> getFuelList() async {
    try {
      final result = await datasource.getFuelList();
      return Right(result);
    } on FuelException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<FuelException, bool>> insert(FuelEntity model) async {
    try {
      final result = await datasource.insert(model);
      return Right(result);
    } on FuelException catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either<FuelException, bool>> delete(FuelEntity model) async {
    try {
      final result = await datasource.delete(model);
      return Right(result);
    } on FuelException catch (e) {
      return Left(e);
    }
  }
}
