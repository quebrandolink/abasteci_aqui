import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../shared/exceptions/fuel_exception.dart';
import '../../domain/entities/fuel_entity.dart';
import '../components/map_widget.dart';
import '../stores/fuel_store.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({this.entity, Key? key}) : super(key: key);
  final FuelEntity? entity;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final store = Modular.get<FuelStore>();

  @override
  void initState() {
    store.getPosition();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: widget.entity != null
            ? BuildMapWidget(
                model: widget.entity!,
                newFuel: false,
              )
            : ScopedBuilder<FuelStore, FuelException, FuelEntity>(
                store: store,
                onState: (context, model) {
                  return BuildMapWidget(
                    model: model,
                    newFuel: true,
                  );
                },
                onError: (context, error) => Center(
                  child: Text(error!.message),
                ),
                onLoading: (context) => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
      ),
    );
  }
}
