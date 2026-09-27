import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';

import '../../core/navigator/navigator.dart';
import '../../core/resources/app_translate.dart';
import '../../core/utils/functions.dart';
import '../../data/models/course_model.dart';
import '../../data/models/enums/lesson_status.dart';
import '../../data/models/lesson_model.dart';
import '../../data/models/lesson_progress_model.dart';
import '../../data/repos/progress_repository.dart';
import '../../domain/progress_rules.dart';
import '../../injection.dart';

class ProgressViewModel with ChangeNotifier {
  final ProgressRepository _progressRepository;
  late Map<String, LessonProgressModel> _progress;
  late Set<String> _completedLessonIds;

  ProgressViewModel({ProgressRepository? progressRepository}) : _progressRepository = progressRepository ?? getIt() {
    _setProgress(_progressRepository.getAllProgress());
  }

  LessonProgressModel? progressOf(String lessonId) => _progress[lessonId];

  LessonStatus statusOf(String lessonId) => ProgressRules.statusOf(_progress[lessonId]);

  bool isCompleted(String lessonId) => _progress[lessonId]?.isCompleted ?? false;

  Set<String> get completedLessonIds => _completedLessonIds;

  bool isUnlocked(CourseModel course, String lessonId) =>
      ProgressRules.isUnlocked(orderedLessonIds: course.lessonIds, lessonId: lessonId, completedLessonIds: completedLessonIds);

  int courseProgressPercent(CourseModel course) =>
      ProgressRules.progressPercent(orderedLessonIds: course.lessonIds, completedLessonIds: completedLessonIds);

  bool isCourseCompleted(CourseModel course) => courseProgressPercent(course) == 100;

  void openLesson(CourseModel course, LessonModel lesson, String languageCode) {
    if (isUnlocked(course, lesson.id)) {
      NavigatorHandler.openLesson(course.id, lesson.id);
    } else {
      showMessage(AppTranslate.lessonLockedMessage(course.lessonBefore(lesson.id)?.title.of(languageCode) ?? ''));
    }
  }

  LessonProgressModel? continueWatching(List<CourseModel> courses) {
    final existing = _progress.values.where((p) {
      for (final course in courses) {
        if (course.id == p.courseId) return course.lessonById(p.lessonId) != null && isUnlocked(course, p.lessonId);
      }
      return false;
    });
    return ProgressRules.latestUnfinished(existing);
  }

  Future<bool> savePosition({required String courseId, required String lessonId, required Duration position, required Duration duration}) async {
    final wasCompleted = isCompleted(lessonId);
    final isCompletedNow = wasCompleted || ProgressRules.reachedCompletion(position: position, duration: duration);
    _setProgress({
      ..._progress,
      lessonId: LessonProgressModel(
        lessonId: lessonId,
        courseId: courseId,
        positionMs: position.inMilliseconds,
        durationMs: duration.inMilliseconds,
        isCompleted: isCompletedNow,
        updatedAt: DateTime.now(),
      ),
    });
    _notifySafely();
    await _progressRepository.saveAllProgress(_progress);
    return isCompletedNow && !wasCompleted;
  }

  Future<void> resetProgress() async {
    _setProgress({});
    _notifySafely();
    await _progressRepository.clearProgress();
  }

  Future<void> confirmResetProgress() async {
    NavigatorHandler.backToHome();
    await resetProgress();
    showMessage(AppTranslate.progressCleared);
  }

  void _setProgress(Map<String, LessonProgressModel> progress) {
    _progress = progress;
    _completedLessonIds = progress.values.where((e) => e.isCompleted).map((e) => e.lessonId).toSet();
  }

  void _notifySafely() {
    if (SchedulerBinding.instance.schedulerPhase == SchedulerPhase.persistentCallbacks) {
      SchedulerBinding.instance.addPostFrameCallback((_) => notifyListeners());
    } else {
      notifyListeners();
    }
  }
}
