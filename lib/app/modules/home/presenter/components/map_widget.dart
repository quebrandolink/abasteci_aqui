import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../domain/entities/fuel_entity.dart';
import '../stores/fuel_store.dart';

class BuildMapWidget extends StatelessWidget {
  const BuildMapWidget({Key? key, required this.model, this.newFuel = true})
      : super(key: key);
  final FuelEntity model;
  final bool newFuel;

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<FuelStore>();
    String date = DateFormat('dd/MM/yyyy HH:mm').format(model.date);
    return Column(
      children: [
        Flexible(
          flex: 2,
          child: GoogleMap(
            scrollGesturesEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(model.latitude!, model.longitude!),
              zoom: 18,
            ),
            zoomControlsEnabled: true,
            mapType: MapType.normal,
            myLocationEnabled: true,
            onMapCreated: newFuel ? store.onMapCreated : null,
          ),
        ),
        model.latitude == 0
            ? const Flexible(
                flex: 1,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : Flexible(
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
                          newFuel
                              ? "CADASTRAR NOVO ABASTECIMENTO"
                              : "ABASTECIMENTO CADASTRADO",
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
                          "${model.address}",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const Spacer(),
                        (newFuel)
                            ? SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    store.insert(model);
                                    Modular.to.pop();
                                  },
                                  icon: const Icon(Ionicons.save_outline),
                                  label: const Text("SALVAR"),
                                ),
                              )
                            : SizedBox(
                                width: double.infinity,
                                height: 40,
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    store.delete(model);
                                    Modular.to.pop();
                                  },
                                  icon: const Icon(Ionicons.trash_outline),
                                  label: const Text("EXCLUIR"),
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
