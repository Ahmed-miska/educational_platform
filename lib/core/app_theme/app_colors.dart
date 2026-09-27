import 'package:flutter/material.dart';

import 'app_palette.dart';

class AppColors {
  AppColors._();

  static bool _isLight(BuildContext context) => Theme.of(context).brightness == Brightness.light;

  static Color mainColor(BuildContext context) => _isLight(context) ? AppPalette.lightMainColor : AppPalette.darkMainColor;

  static Color secondColor(BuildContext context) => _isLight(context) ? AppPalette.lightSecondColor : AppPalette.darkSecondColor;

  static Color darkColor(BuildContext context) => _isLight(context) ? AppPalette.lightDark : AppPalette.darkDark;

  static Color gray(BuildContext context) => darkColor(context).withValues(alpha: .65);

  static Color grayLight(BuildContext context) => darkColor(context).withValues(alpha: .4);

  static Color stroke(BuildContext context) => darkColor(context).withValues(alpha: .08);

  static Color white(BuildContext context) => _isLight(context) ? AppPalette.lightWhite : AppPalette.darkWhite;

  static const Color error = AppPalette.error;
  static const Color completedStatus = AppPalette.green;
  static const Color inProgressStatus = AppPalette.amber;
}
