// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter_triple/flutter_triple.dart';
import 'package:fuel_manager/app/shared/helpers/theme/values/values.dart';
import 'package:fuel_manager/app/shared/theme/theme_store.dart';

// Fictitious brand color.
const _primaryColor = AppColors.primaryColor;

CustomColors lightCustomColors =
    const CustomColors(danger: AppColors.dangerColor);
CustomColors darkCustomColors =
    const CustomColors(danger: AppColors.dangerColor);

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  final themeStore = Modular.get<ThemeStore>();

  @override
  void initState() {
    themeStore.getTheme();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DynamicColorBuilder(
        builder: (ColorScheme? lightDynamic, ColorScheme? darkDynamic) {
      ColorScheme lightColorScheme;
      ColorScheme darkColorScheme;

      if (lightDynamic != null && darkDynamic != null) {
        // On Android S+ devices, use the provided dynamic color scheme.
        // (Recommended) Harmonize the dynamic color scheme' built-in semantic colors.
        lightColorScheme = lightDynamic.harmonized();
        // (Optional) Customize the scheme as desired. For example, one might
        // want to use a brand color to override the dynamic [ColorScheme.secondary].
        lightColorScheme = lightColorScheme.copyWith(secondary: _primaryColor);
        // (Optional) If applicable, harmonize custom colors.
        lightCustomColors = lightCustomColors.harmonized(lightColorScheme);

        // Repeat for the dark color scheme.
        darkColorScheme = darkDynamic.harmonized();
        darkColorScheme = darkColorScheme.copyWith(secondary: _primaryColor);
        darkCustomColors = darkCustomColors.harmonized(darkColorScheme);
      } else {
        // Otherwise, use fallback schemes.
        lightColorScheme = ColorScheme.fromSeed(
          seedColor: _primaryColor,
        );
        darkColorScheme = ColorScheme.fromSeed(
          seedColor: _primaryColor,
          brightness: Brightness.dark,
        );
      }

      return ScopedBuilder<ThemeStore, Exception, bool>(
          store: themeStore,
          onState: (context, isDarkTheme) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'Abasteci Aqui',
              routeInformationParser: Modular.routeInformationParser,
              routerDelegate: Modular.routerDelegate,
              theme: ThemeData(
                useMaterial3: true,
                colorScheme: lightColorScheme,
                extensions: [lightCustomColors],
              ),
              darkTheme: ThemeData(
                useMaterial3: true,
                colorScheme: darkColorScheme,
                extensions: [darkCustomColors],
              ),
              themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,
            );
          });
    });
  }
}

@immutable
class CustomColors extends ThemeExtension<CustomColors> {
  const CustomColors({
    required this.danger,
  });

  final Color? danger;

  @override
  CustomColors copyWith({Color? danger}) {
    return CustomColors(
      danger: danger ?? this.danger,
    );
  }

  @override
  CustomColors lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) {
      return this;
    }
    return CustomColors(
      danger: Color.lerp(danger, other.danger, t),
    );
  }

  CustomColors harmonized(ColorScheme dynamic) {
    return copyWith(danger: danger!.harmonizeWith(dynamic.primary));
  }
}
