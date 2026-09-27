import 'package:educational_platform/data/models/enums/lesson_status.dart';
import 'package:educational_platform/data/models/lesson_progress_model.dart';
import 'package:educational_platform/domain/progress_rules.dart';
import 'package:flutter_test/flutter_test.dart';

LessonProgressModel _progress(String id, {int positionMs = 0, bool completed = false, int updatedAt = 0}) => LessonProgressModel(
  lessonId: id,
  courseId: 'c1',
  positionMs: positionMs,
  durationMs: 100000,
  isCompleted: completed,
  updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAt),
);

void main() {
  group('90% completion rule', () {
    const duration = Duration(seconds: 100);

    test('is not completed just below 90%', () {
      expect(ProgressRules.reachedCompletion(position: const Duration(milliseconds: 89999), duration: duration), isFalse);
    });

    test('is completed at exactly 90% and above', () {
      expect(ProgressRules.reachedCompletion(position: const Duration(seconds: 90), duration: duration), isTrue);
      expect(ProgressRules.reachedCompletion(position: const Duration(seconds: 100), duration: duration), isTrue);
    });

    test('an unknown (zero) duration never counts as completed', () {
      expect(ProgressRules.reachedCompletion(position: const Duration(seconds: 5), duration: Duration.zero), isFalse);
    });
  });

  group('sequential unlock rule', () {
    const ordered = ['l1', 'l2', 'l3'];

    test('the first lesson is always unlocked', () {
      expect(ProgressRules.isUnlocked(orderedLessonIds: ordered, lessonId: 'l1', completedLessonIds: {}), isTrue);
    });

    test('a lesson is locked until the previous one is completed', () {
      expect(ProgressRules.isUnlocked(orderedLessonIds: ordered, lessonId: 'l2', completedLessonIds: {}), isFalse);
      expect(ProgressRules.isUnlocked(orderedLessonIds: ordered, lessonId: 'l2', completedLessonIds: {'l1'}), isTrue);
    });

    test('the rule crosses section boundaries', () {
      expect(ProgressRules.isUnlocked(orderedLessonIds: ordered, lessonId: 'l3', completedLessonIds: {'l1'}), isFalse);
      expect(ProgressRules.isUnlocked(orderedLessonIds: ordered, lessonId: 'l3', completedLessonIds: {'l1', 'l2'}), isTrue);
    });

    test('only the directly previous lesson matters', () {
      expect(ProgressRules.isUnlocked(orderedLessonIds: ordered, lessonId: 'l3', completedLessonIds: {'l2'}), isTrue);
    });

    test('an unknown lesson is locked', () {
      expect(ProgressRules.isUnlocked(orderedLessonIds: ordered, lessonId: 'nope', completedLessonIds: {'l1', 'l2', 'l3'}), isFalse);
    });
  });

  group('course progress %', () {
    const ordered = ['l1', 'l2', 'l3'];

    test('is 0 with nothing completed and 100 with everything completed', () {
      expect(ProgressRules.progressPercent(orderedLessonIds: ordered, completedLessonIds: {}), 0);
      expect(ProgressRules.progressPercent(orderedLessonIds: ordered, completedLessonIds: {'l1', 'l2', 'l3'}), 100);
    });

    test('rounds to a whole percentage', () {
      expect(ProgressRules.progressPercent(orderedLessonIds: ordered, completedLessonIds: {'l1'}), 33);
      expect(ProgressRules.progressPercent(orderedLessonIds: ordered, completedLessonIds: {'l1', 'l2'}), 67);
    });

    test('ignores completed lessons from other courses', () {
      expect(ProgressRules.progressPercent(orderedLessonIds: ordered, completedLessonIds: {'l1', 'other-course-lesson'}), 33);
    });

    test('a course with no lessons is 0%, not a division by zero', () {
      expect(ProgressRules.progressPercent(orderedLessonIds: const [], completedLessonIds: {'l1'}), 0);
    });
  });

  group('lesson status', () {
    test('maps progress to not started / in progress / completed', () {
      expect(ProgressRules.statusOf(null), LessonStatus.notStarted);
      expect(ProgressRules.statusOf(_progress('l1')), LessonStatus.notStarted);
      expect(ProgressRules.statusOf(_progress('l1', positionMs: 1200)), LessonStatus.inProgress);
      expect(ProgressRules.statusOf(_progress('l1', positionMs: 1200, completed: true)), LessonStatus.completed);
    });
  });

  group('resume position', () {
    const duration = Duration(seconds: 60);

    test('resumes from the saved position', () {
      expect(ProgressRules.resumePosition(saved: const Duration(seconds: 20), duration: duration), const Duration(seconds: 20));
    });

    test('restarts when the saved position is at the very end', () {
      expect(ProgressRules.resumePosition(saved: const Duration(seconds: 58), duration: duration), Duration.zero);
      expect(ProgressRules.resumePosition(saved: duration, duration: duration), Duration.zero);
    });
  });

  group('continue watching', () {
    test('picks the most recently watched unfinished lesson', () {
      final latest = ProgressRules.latestUnfinished([
        _progress('old', positionMs: 1000, updatedAt: 1),
        _progress('done', positionMs: 1000, completed: true, updatedAt: 9),
        _progress('recent', positionMs: 1000, updatedAt: 5),
      ]);
      expect(latest?.lessonId, 'recent');
    });

    test('is empty when nothing is in progress', () {
      expect(ProgressRules.latestUnfinished([_progress('done', positionMs: 1, completed: true)]), isNull);
    });
  });
}
