import 'lesson_model.dart';
import 'localized_text.dart';
import 'section_model.dart';

class CourseModel {
  final String id;
  final LocalizedText title;
  final LocalizedText instructor;
  final String thumbnail;
  final List<SectionModel> sections;

  final List<LessonModel> lessons;
  late final List<String> lessonIds = List.unmodifiable(lessons.map((e) => e.id));

  CourseModel({required this.id, required this.title, required this.instructor, required this.thumbnail, required this.sections})
    : lessons = List.unmodifiable(sections.expand((s) => s.lessons));

  factory CourseModel.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! String || id.isEmpty) throw const FormatException('Course is missing an id');
    return CourseModel(
      id: id,
      title: LocalizedText.fromJson(json['title']),
      instructor: LocalizedText.fromJson(json['instructor']),
      thumbnail: json['thumbnail']?.toString() ?? '',
      sections: (json['sections'] as List? ?? []).map((e) => SectionModel.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }

  LessonModel? lessonById(String lessonId) {
    for (final lesson in lessons) {
      if (lesson.id == lessonId) return lesson;
    }
    return null;
  }

  int lessonNumber(String lessonId) => lessonIds.indexOf(lessonId) + 1;

  LessonModel? lessonBefore(String lessonId) {
    final index = lessonIds.indexOf(lessonId);
    return index > 0 ? lessons[index - 1] : null;
  }

  LessonModel? lessonAfter(String lessonId) {
    final index = lessonIds.indexOf(lessonId);
    return index >= 0 && index < lessons.length - 1 ? lessons[index + 1] : null;
  }

  SectionModel? sectionOf(String lessonId) {
    for (final section in sections) {
      if (section.lessons.any((l) => l.id == lessonId)) return section;
    }
    return null;
  }
}
