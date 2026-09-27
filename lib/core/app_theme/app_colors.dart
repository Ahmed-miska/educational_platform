import 'package:flutter/material.dart';

import 'app_colors.dart';

class AppColors {
  AppColors._();

  static bool _isLight(BuildContext context) => Theme.of(context).brightness == Brightness.light;

  static Color mainColor(BuildContext context) => _isLight(context) ? ColorsApp.lightMainColor : ColorsApp.darkMainColor;

  static Color secondColor(BuildContext context) => _isLight(context) ? ColorsApp.lightSecondColor : ColorsApp.darkSecondColor;

  static Color darkColor(BuildContext context) => _isLight(context) ? ColorsApp.lightDark : ColorsApp.darkDark;

  static Color gray(BuildContext context) => darkColor(context).withValues(alpha: .65);

  static Color grayLight(BuildContext context) => darkColor(context).withValues(alpha: .4);

  static Color stroke(BuildContext context) => darkColor(context).withValues(alpha: .08);

  static Color white(BuildContext context) => _isLight(context) ? ColorsApp.lightWhite : ColorsApp.darkWhite;

  static Color bodyBG(BuildContext context) => _isLight(context) ? ColorsApp.lightBodyBG : ColorsApp.darkBodyBG;

  static Color error(BuildContext context) => ColorsApp.error;
  static Color completedStatus(BuildContext context) => ColorsApp.green;
  static Color inProgressStatus(BuildContext context) => ColorsApp.amber;
}
