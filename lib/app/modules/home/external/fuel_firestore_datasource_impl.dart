// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fuel_manager/app/modules/auth/presenters/stores/auth_store.dart';
import 'package:fuel_manager/app/shared/exceptions/fuel_exception.dart';

import '../domain/entities/fuel_entity.dart';
import '../infra/adapters/fuel_entity_adapter.dart';
import '../infra/datasources/fuel_datasource.dart';

class FuelFirestoreDatasourceImpl implements FuelDatasource {
  final FirebaseFirestore firestore;

  FuelFirestoreDatasourceImpl(this.firestore);

  @override
  Future<List<FuelEntity>> getFuelList() async {
    final _authAtore = Modular.get<AuthStore>();
    if (_authAtore.user == null) {
      throw FuelException(
          "Usuário não localizado, por favor, faça o login novamente.");
    }
    final ref = firestore
        .collection("fuel")
        .where("userId", isEqualTo: _authAtore.user!.email)
        .orderBy("date", descending: true);

    final querySnapshot = await ref
        .get()
        .then((querySnapshot) => querySnapshot.docs.map((doc) {
              return FuelEntityAdapter.fromJson({"uid": doc.id, ...doc.data()});
            }).toList())
        .catchError((e) => throw e);

    return querySnapshot;
  }

  @override
  Future<bool> delete(FuelEntity model) async {
    CollectionReference fuelCollection = firestore.collection('fuel');
    return await fuelCollection
        .doc(model.uid)
        .delete()
        .then((value) => true)
        .catchError((error) {
      if (kDebugMode) {
        print({"firebase_error", error});
      }
      throw error;
    });
  }

  @override
  Future<bool> insert(FuelEntity model) async {
    CollectionReference fuelCollection = firestore.collection('fuel');
    return await fuelCollection
        .add(FuelEntityAdapter.toJson(model))
        .then((value) => true)
        .catchError((error) {
      if (kDebugMode) {
        print({"firebase_error", error});
      }
      throw error;
    });
  }
}
