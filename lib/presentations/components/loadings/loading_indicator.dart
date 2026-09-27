import 'package:flutter/material.dart';

import '../../../core/app_theme/app_colors.dart';

class LoadingIndicator extends StatelessWidget {
  final Color? color;

  const LoadingIndicator({super.key, this.color});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(width: 36, height: 36, child: CircularProgressIndicator(color: color ?? AppColors.mainColor(context), strokeWidth: 3)),
    );
  }
}
