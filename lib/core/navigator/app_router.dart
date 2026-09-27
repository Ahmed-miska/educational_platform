import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../presentations/components/custom_app_bar/custom_app_bar.dart';
import '../../presentations/components/custom_scaffold/custom_scaffold.dart';
import '../../presentations/components/no_data/no_data_widget.dart';
import '../../presentations/modules/course_details/course_details_screen.dart';
import '../../presentations/modules/courses/courses_screen.dart';
import '../../presentations/modules/lesson_player/lesson_player_screen.dart';
import '../resources/app_translate.dart';

final navigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  AppRoutes._();

  static const String courses = '/';
  static String courseDetails(String courseId) => '/courses/$courseId';
  static String lesson(String courseId, String lessonId) => '/courses/$courseId/lessons/$lessonId';
}

final GoRouter appRouter = GoRouter(
  navigatorKey: navigatorKey,
  initialLocation: AppRoutes.courses,
  routes: [
    GoRoute(
      path: AppRoutes.courses,
      builder: (context, state) => const CoursesScreen(),
      routes: [
        GoRoute(
          path: 'courses/:courseId',
          builder: (context, state) => CourseDetailsScreen(courseId: state.pathParameters['courseId']!),
          routes: [
            GoRoute(
              path: 'lessons/:lessonId',
              builder: (context, state) =>
                  LessonPlayerScreen(courseId: state.pathParameters['courseId']!, lessonId: state.pathParameters['lessonId']!),
            ),
          ],
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) => CustomScaffold(
    appBar: const CustomAppBar(),
    body: NoDataWidget(message: AppTranslate.pageNotFound, icon: Icons.explore_off_outlined),
  ),
);
