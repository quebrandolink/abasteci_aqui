import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';

class AuthGuard extends RouteGuard {
  AuthGuard() : super(redirectTo: '/');

  @override
  Future<bool> canActivate(String path, ModularRoute route) async {
    if (kDebugMode) {
      print({"route authGuard: ", route.name});
    }
    return FirebaseAuth.instance.currentUser != null;
  }
}
