import 'package:flutter/material.dart';

import '../../../core/app_theme/app_colors.dart';
import '../../../core/dimens/dimens.dart';
import '../../../core/resources/font_size.dart';
import '../custom_text/custom_text.dart';

class CustomButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final IconData? trailingIcon;
  final Color? bg;

  const CustomButton({super.key, required this.title, required this.onTap, this.trailingIcon, this.bg});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: FilledButton(
        onPressed: onTap,
        style: FilledButton.styleFrom(
          backgroundColor: bg ?? AppColors.mainColor(context),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(Dimens.radius12)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          spacing: Dimens.padding8,
          children: [
            Flexible(
              child: CustomText(title: title, fontColor: Colors.white, fontSize: AppFonts.font16, fontWeight: FontWeight.w700, maxLines: 1),
            ),
            if (trailingIcon != null) Icon(trailingIcon, size: 20, color: Colors.white),
          ],
        ),
      ),
    );
  }
}
