import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:intl/intl.dart' as intl;
import 'package:ionicons/ionicons.dart';

import '../../../../shared/helpers/shimmer_container.dart';
import '../../../../shared/helpers/theme/values/values.dart';
import '../../domain/entities/fuel_entity.dart';
import '../stores/home_store.dart';

class LastFuelWidget extends StatelessWidget {
  const LastFuelWidget({
    Key? key,
    required this.model,
    this.isLoading = false,
  }) : super(key: key);

  final FuelEntity model;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<HomeStore>();
    return GestureDetector(
      child: Card(
        color: Theme.of(context).colorScheme.secondary.withOpacity(.01),
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Sizes.DIVISIONS),
            side: BorderSide(
                color: Theme.of(context)
                    .colorScheme
                    .onPrimaryContainer
                    .withOpacity(.1))),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(Sizes.DIVISIONS),
          child: Column(
            children: [
              const SizedBox(height: Sizes.DIVISIONS),
              Text(
                "Último abastecimento".toUpperCase(),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: Sizes.DIVISIONS * 2),
              DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                child: Row(
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
                              Text(model.vehicle != null
                                  ? " ${model.vehicle} "
                                  : " - "),
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
              ),
              const SizedBox(height: Sizes.DIVISIONS),
              DefaultTextStyle(
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(fontWeight: FontWeight.bold),
                child: Row(
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
                              Text(model.liter != null
                                  ? " ${model.liter} ".replaceAll(".", ",")
                                  : " - "),
                            ],
                          ),
                    isLoading
                        ? const ShimmerContainer(
                            height: 20,
                            width: 90,
                          )
                        : Row(
                            children: [
                              Text(intl.DateFormat('dd/MM/yyyy HH:mm', 'pt_BR')
                                  .format(model.date)),
                            ],
                          ),
                  ],
                ),
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
        ),
      ),
      onTap: () async {
        await Modular.to.pushNamed("addfuel", arguments: model);
        store.getList();
      },
    );
  }
}
