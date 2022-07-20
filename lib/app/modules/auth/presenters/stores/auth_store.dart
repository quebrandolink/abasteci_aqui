import 'package:flutter_triple/flutter_triple.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecase.dart';
import '../../../../shared/exceptions/failure_exception.dart';

class AuthStore extends NotifierStore<Failure, UserEntity> {
  final AuthUsecase _authUsecase;
  AuthStore(this._authUsecase) : super(UserEntity());

  Stream<UserEntity?> get checkLoggedUser => _authUsecase.checkSignedUser();

  UserEntity? get user => _authUsecase.user;

  Future<void> signIn() async {
    setLoading(true);
    final result = await _authUsecase.signIn();

    result.fold(setError, update);

    setLoading(false);
  }

  Future<void> signOut() async {
    setLoading(true);
    await _authUsecase.signOut();
    setLoading(false);
  }
}
