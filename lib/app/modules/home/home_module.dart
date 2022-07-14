import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fuel_manager/app/modules/home/domain/usecases/fuel_usecase.dart';
import 'package:fuel_manager/app/modules/home/infra/repositories/fuel_repository_impl.dart';
import 'package:fuel_manager/app/modules/home/presenter/pages/location_page.dart';
import 'package:fuel_manager/app/modules/home/presenter/stores/fuel_store.dart';
import 'external/fuel_firestore_datasource_impl.dart';
import 'presenter/stores/home_store.dart';

import 'domain/repositories/fuel_repository.dart';
import 'presenter/pages/home_page.dart';
import 'infra/datasources/fuel_datasource.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    Bind.singleton((i) => FirebaseFirestore.instance),
    Bind.lazySingleton<FuelDatasource>((i) => FuelFirestoreDatasourceImpl(i())),
    Bind.lazySingleton<FuelRepository>((i) => FuelRepositoryImpl(i())),
    Bind.lazySingleton<FuelUsecase>((i) => FuelUsecaseImpl(i())),
    Bind.lazySingleton((i) => HomeStore(i<FuelUsecaseImpl>())),
    Bind.lazySingleton((i) => FuelStore(i<FuelUsecaseImpl>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => const HomePage()),
    ChildRoute("/addFuel", child: (_, args) => LocationPage(entity: args.data)),
  ];
}
