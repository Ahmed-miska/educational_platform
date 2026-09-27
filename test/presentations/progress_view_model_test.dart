import 'package:educational_platform/core/constants/constants.dart';
import 'package:educational_platform/data/datasource/local/progress_local_data.dart';
import 'package:educational_platform/data/models/enums/lesson_status.dart';
import 'package:educational_platform/data/repos/progress_repository.dart';
import 'package:educational_platform/presentations/modules/progress_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/test_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SharedPreferences prefs;

  ProgressViewModel createViewModel() => ProgressViewModel(
    progressRepository: ProgressRepository(localData: ProgressLocalData(sharedPreferences: prefs)),
  );

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  const duration = Duration(seconds: 60);

  test('watching past 90% completes the lesson and unlocks the next one', () async {
    final viewModel = createViewModel();
    final course = testCourse();

    expect(await viewModel.savePosition(courseId: 'c1', lessonId: 'l1', position: const Duration(seconds: 30), duration: duration), isFalse);
    expect(viewModel.statusOf('l1'), LessonStatus.inProgress);
    expect(viewModel.isUnlocked(course, 'l2'), isFalse);

    expect(await viewModel.savePosition(courseId: 'c1', lessonId: 'l1', position: const Duration(seconds: 54), duration: duration), isTrue);
    expect(viewModel.statusOf('l1'), LessonStatus.completed);
    expect(viewModel.isUnlocked(course, 'l2'), isTrue);
    expect(viewModel.courseProgressPercent(course), 33);
  });

  test('rewatching a completed lesson from the start keeps it completed', () async {
    final viewModel = createViewModel();
    await viewModel.savePosition(courseId: 'c1', lessonId: 'l1', position: duration, duration: duration);

    final justCompleted = await viewModel.savePosition(courseId: 'c1', lessonId: 'l1', position: const Duration(seconds: 3), duration: duration);

    expect(justCompleted, isFalse);
    expect(viewModel.statusOf('l1'), LessonStatus.completed);
  });

  test('progress survives an app restart', () async {
    final before = createViewModel();
    await before.savePosition(courseId: 'c1', lessonId: 'l1', position: duration, duration: duration);
    await before.savePosition(courseId: 'c1', lessonId: 'l2', position: const Duration(seconds: 12), duration: duration);

    final after = createViewModel();

    expect(after.statusOf('l1'), LessonStatus.completed);
    expect(after.progressOf('l2')?.position, const Duration(seconds: 12));
    expect(after.continueWatching([testCourse()])?.lessonId, 'l2');
  });

  test('corrupt stored progress is ignored instead of crashing', () async {
    SharedPreferences.setMockInitialValues({localLessonsProgress: '{not json'});
    prefs = await SharedPreferences.getInstance();

    final viewModel = createViewModel();

    expect(viewModel.statusOf('l1'), LessonStatus.notStarted);
  });

  test('continue watching skips lessons that no longer exist', () async {
    final viewModel = createViewModel();
    await viewModel.savePosition(courseId: 'c1', lessonId: 'removed', position: const Duration(seconds: 5), duration: duration);

    expect(viewModel.continueWatching([testCourse()]), isNull);
  });

  test('reset clears everything', () async {
    final viewModel = createViewModel();
    await viewModel.savePosition(courseId: 'c1', lessonId: 'l1', position: duration, duration: duration);

    await viewModel.resetProgress();

    expect(viewModel.statusOf('l1'), LessonStatus.notStarted);
    expect(createViewModel().statusOf('l1'), LessonStatus.notStarted);
  });
}
