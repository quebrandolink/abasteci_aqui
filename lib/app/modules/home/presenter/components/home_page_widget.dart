import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

import '../../../../shared/helpers/theme/values/values.dart';
import '../../domain/entities/fuel_entity.dart';
import 'fuel_list_item.dart';
import 'last_fuel_widget.dart';

class HomePageWidget extends StatelessWidget {
  const HomePageWidget({
    required this.listFuel,
    Key? key,
    this.isLoading = false,
  }) : super(key: key);

  final List<FuelEntity> listFuel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    animationConfiguration(int index, Widget child) =>
        AnimationConfiguration.staggeredList(
          position: index,
          duration: const Duration(milliseconds: 375),
          child: SlideAnimation(
            verticalOffset: 50.0,
            child: child,
          ),
        );
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Sizes.DIVISIONS),
            AnimationLimiter(
              child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: isLoading ? 4 : listFuel.length,
                  itemBuilder: (context, index) {
                    return animationConfiguration(
                      index,
                      Column(
                        children: [
                          const SizedBox(height: Sizes.DIVISIONS),
                          (index == 1)
                              ? Align(
                                  alignment: Alignment.centerLeft,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: Sizes.DIVISIONS),
                                    child: Text(
                                        "Abastecimentos anteriores"
                                            .toUpperCase(),
                                        textAlign: TextAlign.start,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                  ),
                                )
                              : const SizedBox(),
                          (index == 0)
                              ? LastFuelWidget(
                                  model: isLoading
                                      ? FuelEntity()
                                      : listFuel[index],
                                  isLoading: isLoading,
                                )
                              : FuelListItem(
                                  model: isLoading
                                      ? FuelEntity()
                                      : listFuel[index],
                                  isLoading: isLoading,
                                ),
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
