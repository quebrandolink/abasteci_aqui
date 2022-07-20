import 'package:flutter_modular/flutter_modular.dart';
import 'presenters/pages/auth_page.dart';

class AuthModule extends Module {
  @override
  final List<Bind> binds = [];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => const AuthPage()),
  ];
}
