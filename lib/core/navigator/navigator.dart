import 'app_router.dart';

class NavigatorHandler {
  NavigatorHandler._();

  static void openCourse(String courseId) => appRouter.push(AppRoutes.courseDetails(courseId));

  static void openLesson(String courseId, String lessonId) => appRouter.push(AppRoutes.lesson(courseId, lessonId));

  static void replaceWithLesson(String courseId, String lessonId) => appRouter.pushReplacement(AppRoutes.lesson(courseId, lessonId));

  static void backToHome() => navigatorKey.currentState?.popUntil((route) => route.isFirst);
}
