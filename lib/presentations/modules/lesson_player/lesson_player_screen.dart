import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/resources/app_translate.dart';
import '../../../injection.dart';
import '../../components/custom_app_bar/custom_app_bar.dart';
import '../../components/custom_scaffold/custom_scaffold.dart';
import '../../components/error/custom_error_widget.dart';
import '../../components/loadings/loading_indicator.dart';
import '../../components/no_data/no_data_widget.dart';
import '../courses/courses_view_model.dart';
import '../progress_view_model.dart';
import 'lesson_player_view_model.dart';
import 'widgets/lesson_player_view.dart';

class LessonPlayerScreen extends StatelessWidget {
  final String courseId;
  final String lessonId;

  const LessonPlayerScreen({super.key, required this.courseId, required this.lessonId});

  @override
  Widget build(BuildContext context) {
    AppTranslate.languageCode(context);
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
        final lesson = course?.lessonById(lessonId);
        if (course == null || lesson == null) {
          return CustomScaffold(
            appBar: const CustomAppBar(),
            body: NoDataWidget(message: AppTranslate.lessonNotFound, icon: Icons.search_off_rounded),
          );
        }
        if (!progressViewModel.isUnlocked(course, lesson.id)) {
          return CustomScaffold(
            appBar: const CustomAppBar(),
            body: CustomErrorWidget(message: AppTranslate.lessonLockedTitle, icon: Icons.lock_outline_rounded),
          );
        }
        return ChangeNotifierProvider<LessonPlayerViewModel>(
          create: (_) => getIt<LessonPlayerViewModel>()..init(course: course, lesson: lesson),
          child: const LessonPlayerView(),
        );
      },
    );
  }
}
