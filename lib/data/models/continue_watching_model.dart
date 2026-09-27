import 'course_model.dart';
import 'lesson_model.dart';
import 'lesson_progress_model.dart';

class ContinueWatchingModel {
  final CourseModel course;
  final LessonModel lesson;
  final LessonProgressModel progress;

  const ContinueWatchingModel({required this.course, required this.lesson, required this.progress});

  Duration get duration => progress.durationMs > 0 ? progress.duration : lesson.duration;

  double get watchedFraction => duration.inMilliseconds > 0 ? progress.positionMs / duration.inMilliseconds : 0;

  Duration get timeLeft => duration - progress.position;
}
