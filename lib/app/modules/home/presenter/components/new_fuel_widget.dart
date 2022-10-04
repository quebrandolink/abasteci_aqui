import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../shared/exceptions/fuel_exception.dart';
import '../../../../shared/helpers/theme/values/values.dart';
import '../../domain/entities/fuel_entity.dart';
import '../stores/fuel_store.dart';
import '../stores/home_store.dart';

class NewFuel extends StatefulWidget {
  final FuelEntity model;

  const NewFuel({Key? key, required this.model}) : super(key: key);

  @override
  State<NewFuel> createState() => _NewFuelState();
}

class _NewFuelState extends State<NewFuel> {
  final store = Modular.get<FuelStore>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(Sizes.DIVISIONS),
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          const SizedBox(height: Sizes.DIVISIONS),
          const TextFieldVehicleWidget(),
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
                store.insert(widget.model, context);
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

class TextFieldVehicleWidget extends StatelessWidget {
  const TextFieldVehicleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final store = Modular.get<FuelStore>();

    return ScopedBuilder<HomeStore, FuelException, List<FuelEntity>>(
      store: Modular.get<HomeStore>(),
      onLoading: (context) => const Center(
        child:
            SizedBox(height: 30, width: 30, child: CircularProgressIndicator()),
      ),
      onError: (context, error) => TextFieldWidget(
        controller: store.vehicleController,
        icon: Ionicons.car_outline,
        hintText: "Insira a placa do veículo",
        inputType: TextInputType.streetAddress,
        formatters: [
          PlacaVeiculoInputFormatter(),
        ],
      ),
      onState: (context, listVehicles) {
        List<String> vehiclesList =
            listVehicles.map((e) => e.vehicle!).toSet().toList();

        return Autocomplete(
          onSelected: store.setVehicle,
          optionsBuilder: (TextEditingValue textEditingValue) {
            if (textEditingValue.text.isEmpty) {
              return vehiclesList;
            }
            return vehiclesList.where((vehicle) => vehicle
                .toUpperCase()
                .contains(textEditingValue.text.toUpperCase()));
          },
          optionsViewBuilder: (context, Function(String) onSelected, options) {
            return Material(
              elevation: 4,
              child: ListView.separated(
                  padding: EdgeInsets.zero,
                  separatorBuilder: (context, index) => const Divider(),
                  itemCount: options.length,
                  itemBuilder: (context, index) {
                    final option = options.elementAt(index);

                    return ListTile(
                      title: Text(option.toString()),
                      onTap: () => onSelected(option.toString()),
                    );
                  }),
            );
          },
          initialValue: store.vehicleController.value,
          fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
            store.vehicleController = controller;
            return TextField(
              controller: controller,
              focusNode: focusNode,
              onEditingComplete: onFieldSubmitted,
              inputFormatters: [
                PlacaVeiculoInputFormatter(),
              ],
              keyboardType: TextInputType.streetAddress,
              decoration: const InputDecoration(
                hintText: "Insira a placa do veículo",
                prefixIcon: Icon(
                  Ionicons.car_outline,
                ),
              ),
            );
          },
        );
      },
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
    this.focusNode,
  }) : super(key: key);

  final TextEditingController controller;
  final List<TextInputFormatter>? formatters;
  final TextInputType inputType;
  final String? hintText;
  final IconData? icon;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      focusNode: focusNode,
      inputFormatters: formatters,
      keyboardType: inputType,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: icon != null ? Icon(icon) : null,
      ),
    );
  }
}
