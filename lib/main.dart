// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app/app_module.dart';
import 'app/app_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FlutterConfig.loadEnvVariables();

  initializeDateFormatting("pt_BR");
  Intl.defaultLocale = 'pt_BR';
  runApp(ModularApp(module: AppModule(), child: const AppWidget()));
}
