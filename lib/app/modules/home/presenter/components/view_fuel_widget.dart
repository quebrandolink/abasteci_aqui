import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fuel_manager/app/shared/helpers/theme/values/values.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../domain/entities/fuel_entity.dart';
import '../stores/fuel_store.dart';

class ViewFuel extends StatelessWidget {
  const ViewFuel({Key? key, required this.model}) : super(key: key);
  final FuelEntity model;

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<FuelStore>();

    String date = DateFormat('dd/MM/yyyy HH:mm').format(model.date);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(Sizes.DIVISIONS),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: Sizes.DIVISIONS),
            Text(
              (model.km != null) ? "KM: ${model.km}" : "KM: Não cadastrado",
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Sizes.DIVISIONS),
            Text(
              date,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium!
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: Sizes.DIVISIONS),
            Text(
              "${model.address}",
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width - Sizes.DIVISIONS,
              height: 60,
              child: ElevatedButton.icon(
                onPressed: () {
                  store.delete(model, context);
                },
                icon: const Icon(Ionicons.trash_outline),
                label: const Text("EXCLUIR"),
              ),
            ),
            const SizedBox(height: Sizes.DIVISIONS),
          ],
        ),
      ),
    );
  }
}
