import '../../domain/entities/user_entity.dart';

abstract class AuthDatasource {
  Future<UserEntity> signIn();
  Future<void> signOut();
  Stream<UserEntity?> checkSignedUser();
  UserEntity? get user;
}
