import 'package:flutter/cupertino.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../shared/exceptions/auth_exception.dart';
import '../../../../shared/exceptions/failure_exception.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/usecases/auth_usecase.dart';

class AuthStore extends NotifierStore<Failure, UserEntity> {
  final AuthUsecase _authUsecase;
  AuthStore(this._authUsecase) : super(UserEntity());

  Stream<UserEntity?> get checkLoggedUser => _authUsecase.checkSignedUser();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  UserEntity? get user => _authUsecase.user;

  Future<void> signIn() async {
    setLoading(true);
    if (emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      setError(UserDataEmpty());
    }

    setLoading(true);
    final result = await _authUsecase.signIn(
        emailController.text, passwordController.text);

    result.fold(setError, update);

    setLoading(false);
  }

  Future<void> signInGoogle() async {
    setLoading(true);
    final result = await _authUsecase.signInGoogle();

    result.fold(setError, update);

    setLoading(false);
  }

  Future<void> signInFacebook() async {
    //TODO implementar facebook
  }

  Future<void> signOut() async {
    setLoading(true);
    await _authUsecase.signOut();
    Modular.to.navigate("/auth/");
    setLoading(false);
  }
}
