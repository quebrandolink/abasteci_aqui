import 'package:dartz/dartz.dart';
import '../entities/user_entity.dart';

import '../../../../shared/exceptions/failure_exception.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserEntity>> signIn(String email, String password);
  Future<Either<Failure, UserEntity>> signInGoogle();
  Future<void> signOut();
  Stream<UserEntity?> checkSignedUser();
  UserEntity? get user;
}
