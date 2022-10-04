import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fuel_manager/app/shared/helpers/theme/values/values.dart';

import '../../../../shared/exceptions/fuel_exception.dart';
import '../../../splash/components/splash_widget_lottie.dart';
import '../../domain/entities/fuel_entity.dart';
import '../components/map_widget.dart';
import '../stores/fuel_store.dart';

class LocationPage extends StatefulWidget {
  const LocationPage({this.entity, Key? key, this.lastVehicle})
      : super(key: key);
  final FuelEntity? entity;
  final String? lastVehicle;

  @override
  State<LocationPage> createState() => _LocationPageState();
}

class _LocationPageState extends State<LocationPage> {
  final fuelStore = Modular.get<FuelStore>();

  @override
  void initState() {
    super.initState();
    fuelStore.initState(lastVehicle: widget.lastVehicle, entity: widget.entity);
  }

  @override
  void dispose() {
    fuelStore.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.entity != null
              ? "Visualizar abastecimento.".toUpperCase()
              : "Cadastrar abastecimento".toUpperCase(),
          style: Theme.of(context)
              .textTheme
              .bodyLarge!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
      ),
      body: SafeArea(
        child: widget.entity != null
            ? BuildMapWidget(
                model: widget.entity!,
                newFuel: false,
              )
            : ScopedBuilder<FuelStore, FuelException, FuelEntity>(
                store: fuelStore,
                onState: (context, model) {
                  return BuildMapWidget(
                    model: model,
                    newFuel: true,
                  );
                },
                onError: (context, error) => Column(
                  children: [
                    const SizedBox(height: 100),
                    SplashWidgetLottie(
                        isNetwork: true,
                        lottieFile: Constants.kErrorLottieAnimation,
                        message: error!.message,
                        size: 100),
                  ],
                ),
                onLoading: (context) => Column(
                  children: const [
                    SizedBox(height: 150),
                    SplashWidgetLottie(
                        isNetwork: true,
                        lottieFile: Constants.kfuelLottieAnimation,
                        size: 100),
                  ],
                ),
              ),
      ),
    );
  }
}
