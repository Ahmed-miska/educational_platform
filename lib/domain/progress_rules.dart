import '../data/models/enums/lesson_status.dart';
import '../data/models/lesson_progress_model.dart';

class ProgressRules {
  ProgressRules._();

  static const double completionThreshold = 0.9;

  static const Duration restartThreshold = Duration(seconds: 3);

  static bool reachedCompletion({required Duration position, required Duration duration}) {
    if (duration <= Duration.zero) return false;
    return position.inMilliseconds >= duration.inMilliseconds * completionThreshold;
  }

  static LessonStatus statusOf(LessonProgressModel? progress) {
    if (progress == null) return LessonStatus.notStarted;
    if (progress.isCompleted) return LessonStatus.completed;
    if (progress.positionMs > 0) return LessonStatus.inProgress;
    return LessonStatus.notStarted;
  }

  static bool isUnlocked({required List<String> orderedLessonIds, required String lessonId, required Set<String> completedLessonIds}) {
    final index = orderedLessonIds.indexOf(lessonId);
    if (index < 0) return false;
    if (index == 0) return true;
    return completedLessonIds.contains(orderedLessonIds[index - 1]);
  }

  static int progressPercent({required List<String> orderedLessonIds, required Set<String> completedLessonIds}) {
    if (orderedLessonIds.isEmpty) return 0;
    final completed = orderedLessonIds.where(completedLessonIds.contains).length;
    return (completed * 100 / orderedLessonIds.length).round();
  }

  static Duration resumePosition({required Duration saved, required Duration duration}) {
    if (saved <= Duration.zero) return Duration.zero;
    if (duration <= Duration.zero) return saved;
    if (saved >= duration - restartThreshold) return Duration.zero;
    return saved;
  }

  static LessonProgressModel? latestUnfinished(Iterable<LessonProgressModel> progress) {
    LessonProgressModel? latest;
    for (final item in progress) {
      if (statusOf(item) != LessonStatus.inProgress) continue;
      if (latest == null || item.updatedAt.isAfter(latest.updatedAt)) latest = item;
    }
    return latest;
  }
}
