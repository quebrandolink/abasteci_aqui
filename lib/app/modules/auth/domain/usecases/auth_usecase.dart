import 'package:dartz/dartz.dart';
import '../repositories/auth_repository.dart';
import '../../../../shared/exceptions/failure_exception.dart';
import '../entities/user_entity.dart';

abstract class AuthUsecase {
  Future<Either<Failure, UserEntity>> signIn();
  Future<void> signOut();
  Stream<UserEntity?> checkSignedUser();
  UserEntity? get user;
}

class AuthUsecaseImpl implements AuthUsecase {
  final AuthRepository _repository;

  AuthUsecaseImpl(this._repository);

  @override
  Future<Either<Failure, UserEntity>> signIn() async {
    return await _repository.signIn();
  }

  @override
  Future<void> signOut() async {
    return await _repository.signOut();
  }

  @override
  Stream<UserEntity?> checkSignedUser() {
    return _repository.checkSignedUser();
  }

  @override
  UserEntity? get user => _repository.user;
}
