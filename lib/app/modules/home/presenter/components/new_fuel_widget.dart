import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../shared/helpers/theme/values/values.dart';
import '../../domain/entities/fuel_entity.dart';
import '../stores/fuel_store.dart';

class NewFuel extends StatelessWidget {
  const NewFuel({Key? key, required this.model}) : super(key: key);
  final FuelEntity model;

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<FuelStore>();

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.DIVISIONS),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: Sizes.DIVISIONS),
            SizedBox(
              child: TextField(
                controller: store.kmController,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    hintText: "Insira a quilometragem",
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 20),
                    prefixIcon: const Icon(Ionicons.speedometer_outline),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                          width: 2, color: Theme.of(context).primaryColor),
                      borderRadius: BorderRadius.circular(10.0),
                    )),
              ),
            ),
            const SizedBox(height: Sizes.DIVISIONS),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  store.insert(model, context);
                },
                icon: const Icon(Ionicons.save_outline),
                label: const Text("SALVAR"),
              ),
            ),
            const SizedBox(height: Sizes.DIVISIONS),
          ],
        ),
      ),
    );
  }
}
