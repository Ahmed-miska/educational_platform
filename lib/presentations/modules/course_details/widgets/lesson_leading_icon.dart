import 'package:flutter/material.dart';

import '../../../../core/app_theme/app_colors.dart';
import '../../../../data/models/enums/lesson_status.dart';
import '../../../components/custom_text/custom_text.dart';

class LessonLeadingIcon extends StatelessWidget {
  final int number;
  final LessonStatus status;
  final bool isLocked;

  const LessonLeadingIcon({super.key, required this.number, required this.status, required this.isLocked});

  @override
  Widget build(BuildContext context) {
    final Widget child;
    final Color color;
    if (isLocked) {
      color = AppColors.grayLight(context);
      child = Icon(Icons.lock_rounded, size: 18, color: color);
    } else if (status == LessonStatus.completed) {
      color = AppColors.completedStatus;
      child = Icon(Icons.check_rounded, size: 20, color: color);
    } else if (status == LessonStatus.inProgress) {
      color = AppColors.inProgressStatus;
      child = Icon(Icons.play_arrow_rounded, size: 20, color: color);
    } else {
      color = AppColors.mainColor(context);
      child = CustomText(title: '$number', fontWeight: FontWeight.w700, fontColor: color);
    }
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color.withValues(alpha: .12)),
      child: child,
    );
  }
}
