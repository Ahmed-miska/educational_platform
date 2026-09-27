import 'package:flutter/material.dart';

import '../../../../core/app_theme/colors_theme.dart';
import '../../../../core/dimens/dimens.dart';
import '../../../../core/resources/app_translate.dart';
import '../../../../core/resources/font_size.dart';
import '../../../../data/models/course_model.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../components/images/asset_image.dart';
import '../../../components/progress/app_progress_bar.dart';

class CourseCard extends StatelessWidget {
  final CourseModel course;
  final int progressPercent;
  final bool isCompleted;
  final String languageCode;
  final VoidCallback onTap;

  const CourseCard({
    super.key,
    required this.course,
    required this.progressPercent,
    required this.isCompleted,
    required this.languageCode,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white(context),
      borderRadius: BorderRadius.circular(Dimens.radius16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.padding12),
          child: Row(
            spacing: Dimens.padding12,
            children: [
              AppAssetImage(path: course.thumbnail, width: 96, height: 96, borderRadius: Dimens.radius12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Dimens.padding6,
                  children: [
                    CustomText(title: course.title.of(languageCode), fontSize: AppFonts.font16, fontWeight: FontWeight.w700, maxLines: 2),
                    Row(
                      spacing: Dimens.padding4,
                      children: [
                        Icon(Icons.person_outline_rounded, size: 16, color: AppColors.gray(context)),
                        Flexible(
                          child: CustomText(
                            title: course.instructor.of(languageCode),
                            fontSize: AppFonts.font13,
                            fontColor: AppColors.gray(context),
                            maxLines: 1,
                          ),
                        ),
                        const SizedBox(width: Dimens.padding4),
                        Icon(Icons.play_lesson_outlined, size: 16, color: AppColors.gray(context)),
                        CustomText(
                          title: AppTranslate.lessonsCount(course.lessons.length),
                          fontSize: AppFonts.font13,
                          fontColor: AppColors.gray(context),
                        ),
                      ],
                    ),
                    const SizedBox(height: Dimens.padding4),
                    AppProgressBar(value: progressPercent / 100, color: isCompleted ? AppColors.completedStatus(context) : null),
                    CustomText(
                      title: isCompleted ? AppTranslate.courseCompleted : AppTranslate.completedPercent(progressPercent),
                      fontSize: AppFonts.font12,
                      fontWeight: FontWeight.w500,
                      fontColor: isCompleted ? AppColors.completedStatus(context) : AppColors.mainColor(context),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
