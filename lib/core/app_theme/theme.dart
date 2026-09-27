import 'package:flutter/material.dart';

import 'app_palette.dart';

class AppTheme {
  AppTheme._();

  static const String fontFamily = 'Tajawal';

  static final ThemeData lightTheme = _build(
    brightness: Brightness.light,
    main: AppPalette.lightMainColor,
    surface: AppPalette.lightWhite,
    body: AppPalette.lightBodyBG,
    text: AppPalette.lightDark,
  );

  static final ThemeData darkTheme = _build(
    brightness: Brightness.dark,
    main: AppPalette.darkMainColor,
    surface: AppPalette.darkWhite,
    body: AppPalette.darkBodyBG,
    text: AppPalette.darkDark,
  );

  static ThemeData _build({required Brightness brightness, required Color main, required Color surface, required Color body, required Color text}) {
    return ThemeData(
      brightness: brightness,
      fontFamily: fontFamily,
      scaffoldBackgroundColor: body,
      colorScheme: ColorScheme.fromSeed(seedColor: main, brightness: brightness, primary: main, surface: surface, error: AppPalette.error),
      appBarTheme: AppBarTheme(backgroundColor: body, foregroundColor: text, surfaceTintColor: Colors.transparent, elevation: 0, centerTitle: false),
      snackBarTheme: const SnackBarThemeData(behavior: SnackBarBehavior.floating),
    );
  }
}
