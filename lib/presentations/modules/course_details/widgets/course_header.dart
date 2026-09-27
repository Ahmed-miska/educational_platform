import 'package:flutter/material.dart';

import '../../../../core/app_theme/colors_theme.dart';
import '../../../../core/dimens/dimens.dart';
import '../../../../core/resources/app_translate.dart';
import '../../../../core/resources/font_size.dart';
import '../../../../data/models/course_model.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../components/images/asset_image.dart';
import '../../../components/progress/app_progress_bar.dart';

class CourseHeader extends StatelessWidget {
  final CourseModel course;
  final String languageCode;
  final int progressPercent;

  const CourseHeader({super.key, required this.course, required this.languageCode, required this.progressPercent});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: Dimens.padding8,
      children: [
        AspectRatio(
          aspectRatio: 16 / 9,
          child: AppAssetImage(path: course.thumbnail, width: double.infinity, borderRadius: Dimens.radius16),
        ),
        const SizedBox(height: Dimens.padding4),
        CustomText(title: course.title.of(languageCode), fontSize: AppFonts.font20, fontWeight: FontWeight.w700),
        Row(
          spacing: Dimens.padding4,
          children: [
            Icon(Icons.person_outline_rounded, size: 18, color: AppColors.gray(context)),
            CustomText(title: course.instructor.of(languageCode), fontColor: AppColors.gray(context)),
            const SizedBox(width: Dimens.padding8),
            Icon(Icons.play_lesson_outlined, size: 18, color: AppColors.gray(context)),
            CustomText(title: AppTranslate.lessonsCount(course.lessons.length), fontColor: AppColors.gray(context)),
          ],
        ),
        if (course.lessons.isNotEmpty) ...[
          AppProgressBar(value: progressPercent / 100),
          CustomText(
            title: AppTranslate.completedPercent(progressPercent),
            fontSize: AppFonts.font12,
            fontWeight: FontWeight.w500,
            fontColor: AppColors.mainColor(context),
          ),
        ],
      ],
    );
  }
}
