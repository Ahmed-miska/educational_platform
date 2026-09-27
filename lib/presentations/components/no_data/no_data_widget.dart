import 'package:flutter/material.dart';

import '../../../core/app_theme/app_colors.dart';
import '../../../core/dimens/dimens.dart';
import '../../../core/resources/font_size.dart';
import '../custom_text/custom_text.dart';

class NoDataWidget extends StatelessWidget {
  final String message;
  final IconData icon;

  const NoDataWidget({super.key, required this.message, this.icon = Icons.inbox_outlined});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(Dimens.padding32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: Dimens.padding12,
          children: [
            Icon(icon, size: 56, color: AppColors.grayLight(context)),
            CustomText(title: message, textAlign: TextAlign.center, fontSize: AppFonts.font16, fontColor: AppColors.gray(context)),
          ],
        ),
      ),
    );
  }
}
