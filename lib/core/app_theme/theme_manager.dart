import 'package:flutter/material.dart';

import '../../data/datasource/local/local_user_data.dart';
import '../../injection.dart';

class ThemeManager with ChangeNotifier {
  final LocalUserData _localUserData;
  late ThemeMode _themeMode;

  ThemeManager({LocalUserData? localUserData}) : _localUserData = localUserData ?? getIt() {
    _themeMode = _localUserData.getThemeMode();
  }

  ThemeMode get themeMode => _themeMode;

  bool isDarkMode(BuildContext context) {
    if (_themeMode == ThemeMode.system) {
      return MediaQuery.platformBrightnessOf(context) == Brightness.dark;
    }
    return _themeMode == ThemeMode.dark;
  }

  Future<void> toggleTheme(bool isDark) async {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
    await _localUserData.saveThemeMode(_themeMode);
  }
}
