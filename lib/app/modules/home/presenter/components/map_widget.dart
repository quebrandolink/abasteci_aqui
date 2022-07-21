import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:fuel_manager/app/modules/splash/components/splash_widget_lottie.dart';
import 'package:fuel_manager/app/shared/helpers/theme/values/values.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../domain/entities/fuel_entity.dart';
import '../stores/fuel_store.dart';
import 'new_fuel_widget.dart';
import 'view_fuel_widget.dart';

class BuildMapWidget extends StatefulWidget {
  const BuildMapWidget({Key? key, required this.model, this.newFuel = true})
      : super(key: key);
  final FuelEntity model;
  final bool newFuel;

  @override
  State<BuildMapWidget> createState() => _BuildMapWidgetState();
}

class _BuildMapWidgetState extends State<BuildMapWidget> {
  final store = Modular.get<FuelStore>();
  Set<Marker> markers = <Marker>{};

  setMarker(model) async {
    markers = {};
    markers.add(
      Marker(
        markerId: MarkerId(widget.model.date.toString()),
        position: LatLng(widget.model.latitude!, widget.model.longitude!),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    if (!widget.newFuel) {
      setMarker(widget.model);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const BouncingScrollPhysics(),
      children: [
        ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 250),
          child: GoogleMap(
            scrollGesturesEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(widget.model.latitude!, widget.model.longitude!),
              zoom: 18,
            ),
            zoomControlsEnabled: true,
            mapType: MapType.normal,
            myLocationEnabled: true,
            onMapCreated: (gmc) => store.onMapCreated(
                gmc, Theme.of(context).brightness, widget.model),
            markers: widget.newFuel ? {} : markers,
          ),
        ),
        widget.model.latitude == 0
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  SizedBox(height: 150),
                  SplashWidgetLottie(
                    isNetwork: true,
                    lottieFile: Constants.kfuelLottieAnimation,
                    size: 100,
                  ),
                ],
              )
            : widget.newFuel
                ? NewFuel(model: widget.model)
                : ViewFuel(model: widget.model),
      ],
    );
  }
}
