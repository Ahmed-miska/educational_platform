import 'package:flutter/material.dart';

import '../../../../core/app_theme/app_colors.dart';
import '../../../../core/dimens/dimens.dart';
import '../../../../core/resources/font_size.dart';
import '../../../../core/utils/functions.dart';
import '../../../../data/models/enums/lesson_status.dart';
import '../../../../data/models/lesson_model.dart';
import '../../../components/custom_text/custom_text.dart';
import 'lesson_leading_icon.dart';
import 'lesson_status_badge.dart';

class LessonTile extends StatelessWidget {
  final int number;
  final LessonModel lesson;
  final String languageCode;
  final LessonStatus status;
  final bool isLocked;
  final VoidCallback onTap;

  const LessonTile({
    super.key,
    required this.number,
    required this.lesson,
    required this.languageCode,
    required this.status,
    required this.isLocked,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white(context),
      borderRadius: BorderRadius.circular(Dimens.radius12),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Opacity(
          opacity: isLocked ? .6 : 1,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: Dimens.padding12, vertical: Dimens.padding12),
            child: Row(
              spacing: Dimens.padding12,
              children: [
                LessonLeadingIcon(number: number, status: status, isLocked: isLocked),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: Dimens.padding6,
                    children: [
                      CustomText(title: lesson.title.of(languageCode), fontSize: AppFonts.font14, fontWeight: FontWeight.w500, maxLines: 2),
                      Wrap(
                        spacing: Dimens.padding8,
                        runSpacing: Dimens.padding4,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Icon(Icons.schedule_rounded, size: 14, color: AppColors.gray(context)),
                          CustomText(title: formatDuration(lesson.duration), fontSize: AppFonts.font12, fontColor: AppColors.gray(context)),
                          LessonStatusBadge(status: status, isLocked: isLocked),
                        ],
                      ),
                    ],
                  ),
                ),
                Icon(isLocked ? Icons.lock_outline_rounded : Icons.chevron_right_rounded, color: AppColors.grayLight(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
