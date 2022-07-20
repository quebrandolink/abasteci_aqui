import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import '../../../../shared/helpers/theme/values/values.dart';
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

    return Padding(
      padding: const EdgeInsets.all(Sizes.DIVISIONS),
      child: Column(
        children: [
          const SizedBox(height: Sizes.DIVISIONS * 2),
          DefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    DateFormat('dd/MM/yyyy HH:mm', 'pt_BR').format(model.date)),
              ],
            ),
          ),
          const SizedBox(height: Sizes.DIVISIONS * 2),
          DefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Ionicons.car_outline),
                    Text(model.vehicle != null ? " ${model.vehicle} " : " - "),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Ionicons.speedometer_outline),
                    Text(model.km != null ? " ${model.km} " : " - "),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.DIVISIONS),
          DefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .headlineSmall!
                .copyWith(fontWeight: FontWeight.bold),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Ionicons.color_fill_outline),
                    Text(model.liter != null
                        ? " ${model.liter} ".replaceAll(".", ",")
                        : " - "),
                  ],
                ),
                Row(
                  children: [
                    const Icon(Ionicons.cash_outline),
                    Text(model.valueLiter != null
                        ? " ${model.valueLiter} ".replaceAll(".", ",")
                        : " - "),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.DIVISIONS * 2),
          DefaultTextStyle(
            style: Theme.of(context)
                .textTheme
                .headlineLarge!
                .copyWith(fontWeight: FontWeight.bold),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  children: [
                    const Icon(Ionicons.wallet_outline),
                    Text(model.valueLiter != null && model.liter != null
                        ? " ${NumberFormat.currency(
                            locale: "pt-Br",
                            name: "R\$",
                            decimalDigits: 2,
                          ).format(model.valueLiter! * model.liter!)} "
                            .replaceAll(".", ",")
                        : " - "),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: Sizes.DIVISIONS * 2),
          Text(
            model.address != null ? model.address! : "Endereço não encontrado.",
            style: Theme.of(context).textTheme.bodyMedium,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: Sizes.DIVISIONS * 3),
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
    );
  }
}
