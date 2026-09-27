import 'localized_text.dart';

class LessonModel {
  final String id;
  final LocalizedText title;
  final int durationSec;
  final String video;

  const LessonModel({required this.id, required this.title, required this.durationSec, required this.video});

  Duration get duration => Duration(seconds: durationSec);

  factory LessonModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String || id.isEmpty) throw const FormatException('Lesson is missing an id');
    return LessonModel(
      id: id,
      title: LocalizedText.fromJson(json['title']),
      durationSec: (json['durationSec'] as num?)?.toInt() ?? 0,
      video: json['video']?.toString() ?? '',
    );
  }
}
