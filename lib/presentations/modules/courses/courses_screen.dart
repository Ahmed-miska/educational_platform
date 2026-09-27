import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/dimens/dimens.dart';
import '../../../core/navigator/navigator.dart';
import '../../../core/resources/app_translate.dart';
import '../../../core/resources/font_size.dart';
import '../../components/custom_app_bar/custom_app_bar.dart';
import '../../components/custom_scaffold/custom_scaffold.dart';
import '../../components/custom_text/custom_text.dart';
import '../../components/error/custom_error_widget.dart';
import '../../components/loadings/loading_indicator.dart';
import '../../components/no_data/no_data_widget.dart';
import '../progress_view_model.dart';
import '../settings/settings_sheet.dart';
import 'courses_view_model.dart';
import 'widgets/continue_watching_card.dart';
import 'widgets/course_card.dart';
import 'widgets/search_field.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCode = AppTranslate.languageCode(context);
    return CustomScaffold(
      appBar: CustomAppBar(
        title: AppTranslate.myCourses,
        isBackButtonExist: false,
        actions: [IconButton(tooltip: AppTranslate.settings, icon: const Icon(Icons.tune_rounded), onPressed: () => SettingsSheet.show(context))],
      ),
      body: Consumer2<CoursesViewModel, ProgressViewModel>(
        builder: (context, coursesViewModel, progressViewModel, child) {
          if (coursesViewModel.isError) {
            return CustomErrorWidget(message: AppTranslate.coursesLoadError, onRetry: coursesViewModel.getCourses);
          }
          if (!coursesViewModel.hasLoaded) return const LoadingIndicator();
          if (coursesViewModel.courses.isEmpty) {
            return NoDataWidget(message: AppTranslate.noCourses, icon: Icons.menu_book_outlined);
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(Dimens.padding16, Dimens.padding8, Dimens.padding16, Dimens.padding24),
            children: [
              const SearchField(),
              const SizedBox(height: Dimens.padding16),
              if (coursesViewModel.continueWatching case final item?) ...[
                ContinueWatchingCard(item: item, languageCode: languageCode, onTap: coursesViewModel.openContinueWatching),
                const SizedBox(height: Dimens.padding24),
              ],
              CustomText(title: AppTranslate.allCourses, fontSize: AppFonts.font16, fontWeight: FontWeight.w700),
              const SizedBox(height: Dimens.padding12),
              if (coursesViewModel.filteredCourses.isEmpty)
                NoDataWidget(message: AppTranslate.noSearchResults(coursesViewModel.searchQuery), icon: Icons.search_off_rounded)
              else
                for (final course in coursesViewModel.filteredCourses)
                  Padding(
                    padding: const EdgeInsets.only(bottom: Dimens.padding12),
                    child: CourseCard(
                      course: course,
                      progressPercent: progressViewModel.courseProgressPercent(course),
                      isCompleted: progressViewModel.isCourseCompleted(course),
                      languageCode: languageCode,
                      onTap: () => NavigatorHandler.openCourse(course.id),
                    ),
                  ),
            ],
          );
        },
      ),
    );
  }
}
