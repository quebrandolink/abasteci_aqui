import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:fuel_manager/app/modules/home/domain/entities/fuel_entity.dart';
import 'package:fuel_manager/app/modules/home/infra/adapters/fuel_entity_adapter.dart';
import 'package:fuel_manager/app/modules/home/infra/datasources/fuel_datasource.dart';

class FuelFirestoreDatasourceImpl implements FuelDatasource {
  final FirebaseFirestore firestore;

  FuelFirestoreDatasourceImpl(this.firestore);

  @override
  Future<List<FuelEntity>> getFuelList() async {
    final ref = firestore.collection("fuel");

    final querySnapshot = await ref
        .orderBy("date", descending: true)
        .get()
        .then((querySnapshot) => querySnapshot.docs.map((doc) {
              return FuelEntityAdapter.fromJson({"uid": doc.id, ...doc.data()});
            }).toList());

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
