import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_triple/flutter_triple.dart';

import '../../../../shared/helpers/material_banner_menager.dart';
import '../../../../shared/helpers/theme/values/values.dart';
import '../../../../shared/theme/theme_store.dart';
import '../../../auth/presenters/stores/auth_store.dart';
import '../stores/fuel_store.dart';

class ModalProfileWidget extends StatelessWidget {
  const ModalProfileWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authStore = Modular.get<AuthStore>();
    final themeStore = Modular.get<ThemeStore>();
    final fuelStore = Modular.get<FuelStore>();
    return SizedBox(
      height: 380,
      child: Column(
        children: [
          const SizedBox(height: Sizes.DIVISIONS * 2),
          Center(
            child: Container(
              padding: const EdgeInsets.all(2),
              height: 80,
              width: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: AppColors.primaryColor,
              ),
              child: CircleAvatar(
                backgroundImage: NetworkImage(authStore.user!.photoUrl!),
              ),
            ),
          ),
          const SizedBox(height: Sizes.DIVISIONS),
          Text(
            authStore.user!.name!,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          Text(
            authStore.user!.email!,
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: Sizes.DIVISIONS),
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
                BannerMenager().showWarning(
                    fuelStore.scaffoldKeyFuelStore.currentContext!,
                    "DESEJA REALMENTE FAZER LOGOUT?",
                    actions: [
                      TextButton(
                        style: TextButton.styleFrom(primary: Colors.white),
                        onPressed: () => authStore.signOut(),
                        child: const Text("SIM"),
                      ),
                      TextButton(
                        style: TextButton.styleFrom(primary: Colors.white),
                        onPressed: () => ScaffoldMessenger.of(
                                fuelStore.scaffoldKeyFuelStore.currentContext!)
                            .hideCurrentMaterialBanner(),
                        child: const Text("NÃO"),
                      ),
                    ]);
              },
              child: const Text("LOGOUT"),
            ),
          ),
        ],
      ),
    );
  }
}
