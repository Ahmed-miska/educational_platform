import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/app_theme/app_colors.dart';
import '../../../../core/dimens/dimens.dart';
import '../../../../core/resources/app_translate.dart';
import '../../../../core/resources/font_size.dart';
import '../../../components/custom_button/custom_button.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../course_details/widgets/lesson_status_badge.dart';
import '../../progress_view_model.dart';
import '../lesson_player_view_model.dart';
import 'info_note.dart';

class LessonInfo extends StatelessWidget {
  final String languageCode;

  const LessonInfo({super.key, required this.languageCode});

  @override
  Widget build(BuildContext context) {
    return Consumer2<LessonPlayerViewModel, ProgressViewModel>(
      builder: (context, viewModel, progressViewModel, child) {
        return Padding(
          padding: const EdgeInsets.all(Dimens.padding16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: Dimens.padding8,
            children: [
              CustomText(title: viewModel.subtitle(languageCode), fontSize: AppFonts.font13, fontColor: AppColors.gray(context)),
              CustomText(title: viewModel.lesson.title.of(languageCode), fontSize: AppFonts.font20, fontWeight: FontWeight.w700),
              Row(
                spacing: Dimens.padding8,
                children: [
                  LessonStatusBadge(status: progressViewModel.statusOf(viewModel.lesson.id)),
                  Flexible(
                    child: CustomText(
                      title: viewModel.course.title.of(languageCode),
                      fontSize: AppFonts.font13,
                      fontColor: AppColors.gray(context),
                      maxLines: 1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: Dimens.padding16),
              if (viewModel.nextLesson == null)
                InfoNote(
                  icon: viewModel.isLessonCompleted ? Icons.celebration_outlined : Icons.flag_outlined,
                  message: viewModel.isLessonCompleted ? AppTranslate.courseFinished : AppTranslate.lastLesson,
                )
              else ...[
                CustomButton(
                  title: viewModel.nextLessonTitle(languageCode),
                  trailingIcon: viewModel.canOpenNextLesson ? Icons.arrow_forward_rounded : Icons.lock_outline_rounded,
                  bg: viewModel.canOpenNextLesson ? null : AppColors.grayLight(context),
                  onTap: viewModel.openNextLesson,
                ),
                if (!viewModel.canOpenNextLesson) InfoNote(icon: Icons.info_outline_rounded, message: viewModel.finishLessonFirstMessage),
              ],
            ],
          ),
        );
      },
    );
  }
}
