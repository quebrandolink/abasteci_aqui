import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'auth_guard.dart';
import 'modules/auth/auth_module.dart';
import 'modules/auth/domain/repositories/auth_repository.dart';
import 'modules/auth/domain/usecases/auth_usecase.dart';
import 'modules/auth/external/firebaseauth_datasource_impl.dart';
import 'modules/auth/infra/datasources/auth_datasource.dart';
import 'modules/auth/infra/repositories/auth_repository_impl.dart';
import 'modules/auth/presenters/stores/auth_store.dart';
import 'modules/home/home_module.dart';
import 'modules/splash/splash_module.dart';
import 'shared/theme/theme_change.dart';
import 'shared/theme/theme_store.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    //others
    Bind.singleton((i) => FirebaseAuth.instance),
    Bind.singleton((i) => GoogleSignIn(
          scopes: ['email'],
        )),

    //datasource
    Bind.lazySingleton<AuthDatasource>((i) =>
        FirebaseauthDatasourceImpl(i<FirebaseAuth>(), i<GoogleSignIn>())),

    //repository
    Bind.lazySingleton<AuthRepository>((i) => AuthRepositoryImpl(i())),

    //usecase
    Bind.lazySingleton<AuthUsecase>((i) => AuthUsecaseImpl(i())),

    //store
    Bind.lazySingleton((i) => AuthStore(i<AuthUsecaseImpl>())),
    Bind.singleton((i) => ThemeStore(i())),
    Bind.singleton((i) => ThemeChange()),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: SplashModule()),
    ModuleRoute("/home", module: HomeModule(), guards: [AuthGuard()]),
    ModuleRoute("/auth", module: AuthModule()),
  ];
}
