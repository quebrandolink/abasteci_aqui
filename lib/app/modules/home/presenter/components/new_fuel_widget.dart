import 'package:brasil_fields/brasil_fields.dart';
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

    return Padding(
      padding: const EdgeInsets.all(Sizes.DIVISIONS),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: Sizes.DIVISIONS),
          TextFieldWidget(
              controller: store.vehicleController,
              icon: Ionicons.car_outline,
              hintText: "Insira a placa do veículo",
              inputType: TextInputType.streetAddress,
              formatters: [
                PlacaVeiculoInputFormatter(),
              ]),
          const SizedBox(height: Sizes.DIVISIONS),
          TextFieldWidget(
              controller: store.kmController,
              hintText: "Insira a quilometragem",
              icon: Ionicons.speedometer_outline,
              inputType: TextInputType.number,
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                KmInputFormatter(),
              ]),
          const SizedBox(height: Sizes.DIVISIONS),
          TextFieldWidget(
              controller: store.literController,
              icon: Ionicons.color_fill_outline,
              hintText: "Insira a litragem abastecida",
              inputType: TextInputType.number,
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                CentavosInputFormatter(),
              ]),
          const SizedBox(height: Sizes.DIVISIONS),
          TextFieldWidget(
              controller: store.valueLiterController,
              icon: Ionicons.cash_outline,
              hintText: "Insira o valor do litro",
              inputType: TextInputType.number,
              formatters: [
                FilteringTextInputFormatter.digitsOnly,
                CentavosInputFormatter(),
              ]),
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
    );
  }
}

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    Key? key,
    required this.controller,
    this.inputType = TextInputType.text,
    this.formatters,
    this.hintText,
    this.icon,
  }) : super(key: key);

  final TextEditingController controller;
  final List<TextInputFormatter>? formatters;
  final TextInputType inputType;
  final String? hintText;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: formatters,
      keyboardType: inputType,
      decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          prefixIcon: icon != null ? Icon(icon) : null,
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(width: 1, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10.0),
          ),
          border: OutlineInputBorder(
            borderSide:
                BorderSide(width: 2, color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(10.0),
          )),
    );
  }
}
