import 'package:shared_preferences/shared_preferences.dart';

class ThemeChange {
  late SharedPreferences prefs;

  getSharedPreferences() async {
    prefs = await SharedPreferences.getInstance();
  }

  update() async {
    prefs = await SharedPreferences.getInstance();
    bool isDarkTheme = prefs.getBool("isDarkTheme") ?? false;
    prefs.setBool("isDarkTheme", !isDarkTheme);
  }

  Future<bool> getThemeMode() async {
    prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isDarkTheme") ?? false;
  }
}
