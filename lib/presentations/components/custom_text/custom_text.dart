import 'package:flutter/material.dart';

import '../../../core/app_theme/app_colors.dart';
import '../../../core/resources/font_size.dart';

class CustomText extends StatelessWidget {
  final String? title;
  final Color? fontColor;
  final double? fontSize;
  final FontWeight fontWeight;
  final int? maxLines;
  final TextAlign? textAlign;

  const CustomText({super.key, required this.title, this.fontColor, this.fontSize, this.fontWeight = FontWeight.w400, this.maxLines, this.textAlign});

  @override
  Widget build(BuildContext context) {
    return Text(
      title ?? '',
      maxLines: maxLines,
      overflow: maxLines != null ? TextOverflow.ellipsis : null,
      textAlign: textAlign,
      style: TextStyle(fontSize: fontSize ?? AppFonts.font14, color: fontColor ?? AppColors.darkColor(context), fontWeight: fontWeight),
    );
  }
}
