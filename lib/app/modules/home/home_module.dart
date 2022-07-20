import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'domain/repositories/fuel_repository.dart';
import 'domain/usecases/fuel_usecase.dart';
import 'external/fuel_firestore_datasource_impl.dart';
import 'infra/datasources/fuel_datasource.dart';
import 'infra/repositories/fuel_repository_impl.dart';
import 'presenter/pages/home_page.dart';
import 'presenter/pages/location_page.dart';
import 'presenter/stores/fuel_store.dart';
import 'presenter/stores/home_store.dart';

class HomeModule extends Module {
  @override
  final List<Bind> binds = [
    //others
    Bind.singleton((i) => FirebaseFirestore.instance),

    //datasource
    Bind.lazySingleton<FuelDatasource>((i) => FuelFirestoreDatasourceImpl(i())),

    //repository
    Bind.lazySingleton<FuelRepository>((i) => FuelRepositoryImpl(i())),

    //usecase
    Bind.lazySingleton<FuelUsecase>((i) => FuelUsecaseImpl(i())),

    //store
    Bind.lazySingleton((i) => HomeStore(i<FuelUsecaseImpl>())),
    Bind.lazySingleton((i) => FuelStore(i<FuelUsecaseImpl>())),
  ];

  @override
  final List<ModularRoute> routes = [
    ChildRoute(Modular.initialRoute, child: (_, args) => const HomePage()),
    ChildRoute("/addfuel",
        child: (_, args) => LocationPage(
              entity: args.data,
              lastVehicle: args.queryParams["lastVehicle"],
            ),
        transition: TransitionType.rightToLeftWithFade),
  ];
}
