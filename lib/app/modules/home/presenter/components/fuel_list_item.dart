import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fuel_manager/app/shared/helpers/shimmer_container.dart';
import 'package:fuel_manager/app/shared/helpers/theme/values/values.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../domain/entities/fuel_entity.dart';
import '../stores/home_store.dart';

class FuelListItem extends StatelessWidget {
  const FuelListItem({
    Key? key,
    required this.model,
    this.isLoading = true,
  }) : super(key: key);

  final FuelEntity model;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<HomeStore>();
    return ListTile(
      style: ListTileStyle.list,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizes.DIVISIONS),
          side: BorderSide(
              color: Theme.of(context)
                  .colorScheme
                  .onPrimaryContainer
                  .withOpacity(.1))),
      contentPadding: const EdgeInsets.all(Sizes.DIVISIONS),
      isThreeLine: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          isLoading
              ? const ShimmerContainer(
                  height: 20,
                  width: 70,
                )
              : Row(
                  children: [
                    const Icon(Ionicons.car_outline),
                    Text(model.vehicle != null ? " ${model.vehicle} " : " - "),
                  ],
                ),
          isLoading
              ? const ShimmerContainer(
                  height: 20,
                  width: 70,
                )
              : Row(
                  children: [
                    const Icon(Ionicons.speedometer_outline),
                    Text(model.km != null ? " ${model.km} " : " - "),
                  ],
                ),
        ],
      ),
      subtitle: Column(
        children: [
          const SizedBox(height: Sizes.DIVISIONS),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              isLoading
                  ? const ShimmerContainer(
                      height: 20,
                      width: 75,
                    )
                  : Row(
                      children: [
                        const Icon(Ionicons.color_fill_outline),
                        Text(model.liter != null ? " ${model.liter} " : " - "),
                      ],
                    ),
              isLoading
                  ? const ShimmerContainer(
                      height: 20,
                      width: 90,
                    )
                  : Row(
                      children: [
                        Text(DateFormat('dd/MM/yyyy HH:mm', 'pt_BR')
                            .format(model.date)),
                      ],
                    ),
            ],
          ),
          const SizedBox(height: Sizes.DIVISIONS),
          isLoading
              ? const ShimmerContainer(
                  height: 20,
                  width: double.infinity,
                )
              : Text(
                  model.address != null
                      ? model.address!
                      : "Endereço não encontrado.",
                  style: Theme.of(context).textTheme.caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
        ],
      ),
      onTap: isLoading
          ? () {}
          : () async {
              var result =
                  await Modular.to.pushNamed("addfuel", arguments: model);
              print("result: $result");

              if (result != null) {
                store.getList();
              }
            },
    );
  }
}
