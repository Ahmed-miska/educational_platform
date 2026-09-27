class LessonProgressModel {
  final String lessonId;
  final String courseId;
  final int positionMs;
  final int durationMs;
  final bool isCompleted;
  final DateTime updatedAt;

  const LessonProgressModel({
    required this.lessonId,
    required this.courseId,
    required this.positionMs,
    required this.durationMs,
    required this.isCompleted,
    required this.updatedAt,
  });

  Duration get position => Duration(milliseconds: positionMs);
  Duration get duration => Duration(milliseconds: durationMs);

  factory LessonProgressModel.fromJson(Map<String, dynamic> json) => LessonProgressModel(
    lessonId: json['lessonId'] as String,
    courseId: json['courseId'] as String,
    positionMs: (json['positionMs'] as num?)?.toInt() ?? 0,
    durationMs: (json['durationMs'] as num?)?.toInt() ?? 0,
    isCompleted: json['isCompleted'] as bool? ?? false,
    updatedAt: DateTime.fromMillisecondsSinceEpoch((json['updatedAt'] as num?)?.toInt() ?? 0),
  );

  Map<String, dynamic> toJson() => {
    'lessonId': lessonId,
    'courseId': courseId,
    'positionMs': positionMs,
    'durationMs': durationMs,
    'isCompleted': isCompleted,
    'updatedAt': updatedAt.millisecondsSinceEpoch,
  };
}
