import 'package:educational_platform/data/datasource/local/progress_local_data.dart';
import 'package:educational_platform/data/models/course_model.dart';
import 'package:educational_platform/data/repos/courses_repository.dart';
import 'package:educational_platform/data/repos/progress_repository.dart';
import 'package:educational_platform/presentations/modules/course_details/course_details_screen.dart';
import 'package:educational_platform/presentations/modules/courses/courses_screen.dart';
import 'package:educational_platform/presentations/modules/courses/courses_view_model.dart';
import 'package:educational_platform/presentations/modules/progress_view_model.dart';
import 'package:educational_platform/core/app_theme/theme_manager.dart';
import 'package:educational_platform/core/utils/functions.dart';
import 'package:educational_platform/data/datasource/local/local_user_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_data.dart';

void main() {
  late CoursesViewModel coursesViewModel;
  late ProgressViewModel progressViewModel;
  late SharedPreferences prefs;

  Future<void> pumpScreen(WidgetTester tester, Widget screen, {List<CourseModel>? courses, bool failLoading = false}) async {
    coursesViewModel = CoursesViewModel(
      coursesRepository: CoursesRepository(dataSource: FakeCoursesDataSource(courses ?? [testCourse()], fail: failLoading)),
      progressViewModel: progressViewModel,
    );
    await coursesViewModel.getCourses();
    tester.view.physicalSize = const Size(1080, 2400);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: coursesViewModel),
          ChangeNotifierProvider.value(value: progressViewModel),
          ChangeNotifierProvider(
            create: (_) => ThemeManager(localUserData: LocalUserData(sharedPreferences: prefs)),
          ),
        ],
        child: MaterialApp(scaffoldMessengerKey: scaffoldMessengerKey, home: screen),
      ),
    );
  }

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    progressViewModel = ProgressViewModel(
      progressRepository: ProgressRepository(localData: ProgressLocalData(sharedPreferences: prefs)),
    );
  });

  group('CourseDetailsScreen', () {
    testWidgets('only the first lesson is open at the start, and a locked lesson explains why', (tester) async {
      await pumpScreen(tester, const CourseDetailsScreen(courseId: 'c1'));

      expect(find.text('القسم الأول'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline_rounded), findsNWidgets(2));

      await tester.tap(find.text('درس l2'));
      await tester.pump();

      expect(find.widgetWithText(SnackBar, 'lessonLockedMessage'), findsOneWidget);
    });

    testWidgets('completing a lesson marks it and unlocks the next one', (tester) async {
      await progressViewModel.savePosition(
        courseId: 'c1',
        lessonId: 'l1',
        position: const Duration(seconds: 60),
        duration: const Duration(seconds: 60),
      );
      await pumpScreen(tester, const CourseDetailsScreen(courseId: 'c1'));

      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    });

    testWidgets('a course with no lessons shows an empty state', (tester) async {
      await pumpScreen(tester, const CourseDetailsScreen(courseId: 'empty'), courses: [emptyCourse()]);

      expect(find.text('noLessonsYet'), findsOneWidget);
    });

    testWidgets('an unknown course id shows a not-found state', (tester) async {
      await pumpScreen(tester, const CourseDetailsScreen(courseId: 'missing'));

      expect(find.text('courseNotFound'), findsOneWidget);
    });
  });

  group('CoursesScreen', () {
    testWidgets('shows "Continue watching" only when a lesson is unfinished', (tester) async {
      await pumpScreen(tester, const CoursesScreen());
      expect(find.text('continueWatching'), findsNothing);

      await progressViewModel.savePosition(
        courseId: 'c1',
        lessonId: 'l1',
        position: const Duration(seconds: 20),
        duration: const Duration(seconds: 60),
      );
      await tester.pump();

      expect(find.text('continueWatching'), findsOneWidget);
    });

    testWidgets('search filters courses and shows an empty result state', (tester) async {
      await pumpScreen(tester, const CoursesScreen(), courses: [testCourse(), emptyCourse()]);
      expect(find.text('مقدمة في التشريح'), findsOneWidget);
      expect(find.text('علم الأدوية'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'ادوية');
      await tester.pump();
      expect(find.text('مقدمة في التشريح'), findsNothing);
      expect(find.text('علم الأدوية'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'xyz');
      await tester.pump();
      expect(find.text('noSearchResults'), findsOneWidget);
    });

    testWidgets('a corrupt data file shows an error with retry, not a red screen', (tester) async {
      await pumpScreen(tester, const CoursesScreen(), failLoading: true);

      expect(find.text('coursesLoadError'), findsOneWidget);
      expect(find.text('tryAgain'), findsOneWidget);
    });
  });
}
