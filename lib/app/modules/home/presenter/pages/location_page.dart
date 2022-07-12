import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../shared/exceptions/fuel_exception.dart';
import '../../domain/entities/fuel_entity.dart';
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
              )
            : ScopedBuilder<FuelStore, FuelException, FuelEntity>(
                store: store,
                onState: (context, model) {
                  return BuildMapWidget(
                    model: model,
                    store: store,
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

class BuildMapWidget extends StatelessWidget {
  const BuildMapWidget({Key? key, required this.model, this.store})
      : super(key: key);
  final FuelEntity model;
  final FuelStore? store;

  @override
  Widget build(BuildContext context) {
    String date = DateFormat('dd/MM/yyyy HH:mm').format(model.date);
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(model.latitude!, model.longitude!),
              zoom: 18,
            ),
            zoomControlsEnabled: true,
            mapType: MapType.normal,
            myLocationEnabled: true,
            onMapCreated: store != null ? store!.onMapCreated : null,
          ),
        ),
        Flexible(
          flex: 1,
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    store == null
                        ? "ABASTECIMENTO CADASTRADO"
                        : "CADASTRAR NOVO ABASTECIMENTO",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Spacer(),
                  Text(
                    date,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "${model.latitude.toString()}, ${model.longitude.toString()}",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const Spacer(),
                  if (store != null)
                    SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          store!.insert(model: model);
                          Modular.to.pop();
                        },
                        icon: const Icon(Ionicons.save_outline),
                        label: const Text("SALVAR"),
                      ),
                    ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    height: 40,
                    child: OutlinedButton.icon(
                      onPressed: () {
                        Modular.to.pop();
                      },
                      icon: const Icon(Ionicons.return_down_back),
                      label: const Text("SAIR"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
