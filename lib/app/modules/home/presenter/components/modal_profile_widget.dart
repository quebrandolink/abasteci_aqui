import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fuel_manager/app/modules/home/domain/entities/fuel_entity.dart';
import 'package:fuel_manager/app/modules/home/presenter/stores/home_store.dart';
import 'package:fuel_manager/app/shared/exceptions/fuel_exception.dart';
import 'package:ionicons/ionicons.dart';

import '../../../../shared/helpers/material_banner_menager.dart';
import '../../../../shared/helpers/theme/values/values.dart';
import '../../../../shared/theme/theme_store.dart';
import '../../../auth/presenters/stores/auth_store.dart';
import '../stores/fuel_store.dart';

class ModalProfileWidget extends StatefulWidget {
  const ModalProfileWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<ModalProfileWidget> createState() => _ModalProfileWidgetState();
}

class _ModalProfileWidgetState extends State<ModalProfileWidget> {
  final authStore = Modular.get<AuthStore>();
  final themeStore = Modular.get<ThemeStore>();
  final fuelStore = Modular.get<FuelStore>();
  final homeStore = Modular.get<HomeStore>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Widget vehicleChip(String title) {
      return Chip(
        label: Text(
          title,
          style: Theme.of(context).textTheme.labelLarge,
        ),
      );
    }

    return SizedBox(
      height: 500,
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(Sizes.DIVISIONS),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: Sizes.DIVISIONS * 2),
            Row(
              children: [
                Center(
                  child: Container(
                    height: 80,
                    width: 80,
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.primaryColor,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: CachedNetworkImageProvider(
                              authStore.user!.photoUrl!),
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: Sizes.DIVISIONS),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      authStore.user!.name!,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      authStore.user!.email!,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: Sizes.DIVISIONS * 2),
            Row(
              children: [
                Text(
                  "VEÍCULOS CADASTRADOS",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                    onPressed: homeStore.getList,
                    icon: const Icon(Ionicons.refresh))
              ],
            ),
            const SizedBox(height: Sizes.DIVISIONS),
            ScopedBuilder<HomeStore, FuelException, List<FuelEntity>>(
              store: homeStore,
              onLoading: (context) => const Center(
                child: SizedBox(
                    height: 30, width: 30, child: CircularProgressIndicator()),
              ),
              onError: ((context, error) => Center(
                    child: Text(
                        "Ocorreu um erro ao buscar os veículos. ${error!.message}"),
                  )),
              onState: (context, listVehicles) {
                if (listVehicles.isEmpty) {
                  return const Center(
                    child: Text("Não há veículos cadastrados."),
                  );
                }
                List<String> vehiclesList =
                    listVehicles.map((e) => e.vehicle!).toSet().toList();
                return Wrap(
                  spacing: Sizes.DIVISIONS / 2,
                  children: [
                    ...vehiclesList.map((vehicle) => vehicleChip(vehicle)),
                  ],
                );
              },
            ),
            const SizedBox(height: Sizes.DIVISIONS * 2),
            ScopedBuilder<ThemeStore, Exception, bool>(
                store: themeStore,
                onState: (context, isDarkTheme) {
                  return SwitchListTile(
                      value: isDarkTheme,
                      title: const Text("MUDAR TEMA"),
                      onChanged: (value) => themeStore.changeTheme());
                }),
            const SizedBox(height: Sizes.DIVISIONS * 2),
            SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  showMessageLogout();
                },
                child: const Text("LOGOUT"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  BannerMenager showMessageLogout() => BannerMenager().showWarning(
          fuelStore.scaffoldKeyFuelStore.currentContext!,
          "DESEJA REALMENTE FAZER LOGOUT?",
          actions: [
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () {
                ScaffoldMessenger.of(
                        fuelStore.scaffoldKeyFuelStore.currentContext!)
                    .hideCurrentMaterialBanner();
                authStore.signOut();
              },
              child: const Text("SIM"),
            ),
            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed: () => ScaffoldMessenger.of(
                      fuelStore.scaffoldKeyFuelStore.currentContext!)
                  .hideCurrentMaterialBanner(),
              child: const Text("NÃO"),
            ),
          ]);
}
