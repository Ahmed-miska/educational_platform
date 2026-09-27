import 'package:flutter/material.dart';

import '../../../../core/app_theme/app_colors.dart';
import '../../../../core/dimens/dimens.dart';
import '../../../../core/resources/app_translate.dart';
import '../../../../core/resources/font_size.dart';
import '../../../../data/models/enums/lesson_status.dart';
import '../../../components/custom_text/custom_text.dart';

class LessonStatusBadge extends StatelessWidget {
  final LessonStatus status;
  final bool isLocked;

  const LessonStatusBadge({super.key, required this.status, this.isLocked = false});

  @override
  Widget build(BuildContext context) {
    final (label, color) = isLocked
        ? (AppTranslate.statusLocked, AppColors.grayLight(context))
        : switch (status) {
            LessonStatus.notStarted => (AppTranslate.statusNotStarted, AppColors.gray(context)),
            LessonStatus.inProgress => (AppTranslate.statusInProgress, AppColors.inProgressStatus),
            LessonStatus.completed => (AppTranslate.statusCompleted, AppColors.completedStatus),
          };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: Dimens.padding8, vertical: 2),
      decoration: BoxDecoration(color: color.withValues(alpha: .12), borderRadius: BorderRadius.circular(Dimens.radius8)),
      child: CustomText(title: label, fontSize: AppFonts.font11, fontWeight: FontWeight.w500, fontColor: color),
    );
  }
}
