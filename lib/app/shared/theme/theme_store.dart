// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter_triple/flutter_triple.dart';

import 'package:fuel_manager/app/shared/theme/theme_change.dart';

class ThemeStore extends NotifierStore<Exception, bool> {
  final ThemeChange themeChange;

  ThemeStore(this.themeChange) : super(false);

  Future<void> getTheme() async {
    bool isDark = state;

    isDark = await themeChange.getThemeMode();

    update(isDark);
  }

  Future<void> changeTheme() async {
    await themeChange.update();
  }
}
