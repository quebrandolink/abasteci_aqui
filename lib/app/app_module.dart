import 'package:flutter_modular/flutter_modular.dart';
import 'package:fuel_manager/app/shared/theme/theme_change.dart';

import 'modules/home/home_module.dart';
import 'shared/theme/theme_store.dart';

class AppModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => ThemeChange()),
    Bind.singleton((i) => ThemeStore(i())),
  ];

  @override
  final List<ModularRoute> routes = [
    ModuleRoute(Modular.initialRoute, module: HomeModule()),
  ];
}
