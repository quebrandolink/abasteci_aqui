import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
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

  setFuelMarker(model) async {
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
    setFuelMarker(widget.model);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          flex: 2,
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
            ? const Flexible(
                flex: 1,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            : widget.newFuel
                ? NewFuel(model: widget.model)
                : ViewFuel(model: widget.model),
      ],
    );
  }
}
