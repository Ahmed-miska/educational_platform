import 'package:flutter/material.dart';

import '../../../core/app_theme/colors_theme.dart';

class AppProgressBar extends StatelessWidget {
  final double value;
  final Color? color;

  const AppProgressBar({super.key, required this.value, this.color});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: LinearProgressIndicator(
        value: value.clamp(0, 1),
        minHeight: 6,
        backgroundColor: AppColors.stroke(context),
        color: color ?? AppColors.mainColor(context),
      ),
    );
  }
}
