import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme/app_colors.dart';
import '../../../core/dimens/dimens.dart';
import '../../../core/resources/app_translate.dart';
import '../../../core/resources/font_size.dart';
import '../../components/custom_app_bar/custom_app_bar.dart';
import '../../components/custom_scaffold/custom_scaffold.dart';
import '../../components/custom_text/custom_text.dart';
import '../../components/error/custom_error_widget.dart';
import '../../components/loadings/loading_indicator.dart';
import '../../components/no_data/no_data_widget.dart';
import '../courses/courses_view_model.dart';
import '../progress_view_model.dart';
import 'widgets/course_header.dart';
import 'widgets/lesson_tile.dart';

class CourseDetailsScreen extends StatelessWidget {
  final String courseId;

  const CourseDetailsScreen({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    final languageCode = AppTranslate.languageCode(context);
    return Consumer2<CoursesViewModel, ProgressViewModel>(
      builder: (context, coursesViewModel, progressViewModel, child) {
        if (!coursesViewModel.hasLoaded) {
          return CustomScaffold(
            appBar: const CustomAppBar(),
            body: coursesViewModel.isError
                ? CustomErrorWidget(message: AppTranslate.coursesLoadError, onRetry: coursesViewModel.getCourses)
                : const LoadingIndicator(),
          );
        }
        final course = coursesViewModel.courseById(courseId);
        if (course == null) {
          return CustomScaffold(
            appBar: const CustomAppBar(),
            body: NoDataWidget(message: AppTranslate.courseNotFound, icon: Icons.search_off_rounded),
          );
        }

        return CustomScaffold(
          appBar: CustomAppBar(title: course.title.of(languageCode)),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(Dimens.padding16, Dimens.padding8, Dimens.padding16, Dimens.padding24),
            children: [
              CourseHeader(course: course, languageCode: languageCode, progressPercent: progressViewModel.courseProgressPercent(course)),
              if (course.lessons.isEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: Dimens.padding32),
                  child: NoDataWidget(message: AppTranslate.noLessonsYet, icon: Icons.video_library_outlined),
                )
              else
                for (final section in course.sections) ...[
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: Dimens.padding24, bottom: Dimens.padding8, start: Dimens.padding4),
                    child: CustomText(title: section.title.of(languageCode), fontSize: AppFonts.font16, fontWeight: FontWeight.w700),
                  ),
                  if (section.lessons.isEmpty)
                    CustomText(title: AppTranslate.noLessonsInSection, fontColor: AppColors.gray(context))
                  else
                    for (final lesson in section.lessons)
                      Padding(
                        padding: const EdgeInsets.only(bottom: Dimens.padding8),
                        child: LessonTile(
                          number: course.lessonNumber(lesson.id),
                          lesson: lesson,
                          languageCode: languageCode,
                          status: progressViewModel.statusOf(lesson.id),
                          isLocked: !progressViewModel.isUnlocked(course, lesson.id),
                          onTap: () => progressViewModel.openLesson(course, lesson, languageCode),
                        ),
                      ),
                ],
            ],
          ),
        );
      },
    );
  }
}
