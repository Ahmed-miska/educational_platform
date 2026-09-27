import 'package:flutter/material.dart';

import '../../../core/app_theme/colors_theme.dart';
import '../../../core/dimens/dimens.dart';
import '../../../core/resources/app_translate.dart';
import '../../../core/resources/font_size.dart';
import '../custom_text/custom_text.dart';

class CustomErrorWidget extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;
  final IconData icon;
  final Color? color;

  const CustomErrorWidget({super.key, required this.message, this.onRetry, this.icon = Icons.error_outline_rounded, this.color});

  @override
  Widget build(BuildContext context) {
    final foreground = color ?? AppColors.gray(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.padding24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Dimens.padding12,
          children: [
            Icon(icon, size: 48, color: color ?? AppColors.error(context)),
            CustomText(title: message, textAlign: TextAlign.center, fontSize: AppFonts.font14, fontColor: foreground),
            if (onRetry != null)
              TextButton.icon(
                onPressed: onRetry,
                icon: Icon(Icons.refresh_rounded, color: color ?? AppColors.mainColor(context)),
                label: CustomText(title: AppTranslate.tryAgain, fontWeight: FontWeight.w700, fontColor: color ?? AppColors.mainColor(context)),
              ),
          ],
        ),
      ),
    );
  }
}
