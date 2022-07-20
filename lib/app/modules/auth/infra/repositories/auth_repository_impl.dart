import '../../domain/entities/user_entity.dart';
import 'package:dartz/dartz.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

import '../../../../shared/exceptions/failure_exception.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthDatasource _authDatasource;

  AuthRepositoryImpl(this._authDatasource);

  @override
  Future<Either<Failure, UserEntity>> signIn() async {
    try {
      final result = await _authDatasource.signIn();
      return Right(result);
    } on Failure catch (e) {
      return Left(e);
    }
  }

  @override
  Future<void> signOut() async {
    return await _authDatasource.signOut();
  }

  @override
  Stream<UserEntity?> checkSignedUser() {
    return _authDatasource.checkSignedUser();
  }

  @override
  UserEntity? get user => _authDatasource.user;
}
