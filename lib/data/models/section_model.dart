import 'lesson_model.dart';
import 'localized_text.dart';

class SectionModel {
  final String id;
  final LocalizedText title;
  final List<LessonModel> lessons;

  const SectionModel({required this.id, required this.title, required this.lessons});

  factory SectionModel.fromJson(Map<String, dynamic> json) => SectionModel(
    id: json['id']?.toString() ?? '',
    title: LocalizedText.fromJson(json['title']),
    lessons: (json['lessons'] as List? ?? []).map((e) => LessonModel.fromJson(e as Map<String, dynamic>)).toList(),
  );
}
