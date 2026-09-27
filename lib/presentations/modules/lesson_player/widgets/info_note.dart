import 'package:flutter/material.dart';

import '../../../../core/app_theme/app_colors.dart';
import '../../../../core/dimens/dimens.dart';
import '../../../../core/resources/font_size.dart';
import '../../../components/custom_text/custom_text.dart';

class InfoNote extends StatelessWidget {
  final IconData icon;
  final String message;

  const InfoNote({super.key, required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: Dimens.padding8,
      children: [
        Icon(icon, size: 18, color: AppColors.gray(context)),
        Expanded(
          child: CustomText(title: message, fontSize: AppFonts.font13, fontColor: AppColors.gray(context)),
        ),
      ],
    );
  }
}
