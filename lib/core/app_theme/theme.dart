import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static const String fontFamily = 'Tajawal';

  static ThemeData lightTheme = _build(
    brightness: Brightness.light,
    main: ColorsApp.lightMainColor,
    surface: ColorsApp.lightWhite,
    body: ColorsApp.lightBodyBG,
    text: ColorsApp.lightDark,
  );

  static ThemeData darkTheme = _build(
    brightness: Brightness.dark,
    main: ColorsApp.darkMainColor,
    surface: ColorsApp.darkWhite,
    body: ColorsApp.darkBodyBG,
    text: ColorsApp.darkDark,
  );

  static ThemeData _build({required Brightness brightness, required Color main, required Color surface, required Color body, required Color text}) {
    return ThemeData(
      brightness: brightness,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: body,
      colorScheme: ColorScheme.fromSeed(seedColor: main, brightness: brightness, primary: main, surface: surface, error: ColorsApp.error),
      appBarTheme: AppBarTheme(backgroundColor: body, foregroundColor: text, surfaceTintColor: Colors.transparent, elevation: 0, centerTitle: false),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}
