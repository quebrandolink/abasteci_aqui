import '../../domain/entities/user_entity.dart';

abstract class AuthDatasource {
  Future<UserEntity> signIn(String email, String password);
  Future<UserEntity> signInGoogle();
  Future<void> signOut();
  Stream<UserEntity?> checkSignedUser();
  UserEntity? get user;
}
