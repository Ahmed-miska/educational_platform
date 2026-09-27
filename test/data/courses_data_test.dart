import 'dart:convert';
import 'dart:io';

import 'package:educational_platform/data/models/course_model.dart';
import 'package:educational_platform/data/models/localized_text.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('bundled courses.json', () {
    final json = jsonDecode(File('assets/data/courses.json').readAsStringSync()) as Map<String, dynamic>;
    final courses = (json['courses'] as List).map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();

    test('parses', () {
      expect(courses, isNotEmpty);
    });

    test('lesson ids are unique across all courses, since progress is keyed by lesson id', () {
      final ids = courses.expand((c) => c.lessonIds).toList();
      expect(ids.toSet().length, ids.length);
    });

    test('every referenced thumbnail and video exists, except the one kept missing on purpose', () {
      final missing = [
        for (final course in courses) ...[
          if (!File(course.thumbnail).existsSync()) course.thumbnail,
          for (final lesson in course.lessons)
            if (!File(lesson.video).existsSync()) lesson.video,
        ],
      ];
      expect(missing, ['assets/videos/missing_lesson.mp4']);
    });
  });

  group('models', () {
    test('LocalizedText accepts a plain string or an ar/en map and falls back to Arabic', () {
      expect(LocalizedText.fromJson('العظام').of('en'), 'العظام');
      expect(LocalizedText.fromJson({'ar': 'العظام', 'en': 'Bones'}).of('en'), 'Bones');
      expect(LocalizedText.fromJson({'ar': 'العظام'}).of('en'), 'العظام');
    });

    test('a course without sections has no lessons instead of failing', () {
      final course = CourseModel.fromJson({'id': 'x', 'title': 'x', 'instructor': 'y'});
      expect(course.lessons, isEmpty);
    });

    test('a lesson without an id is rejected', () {
      expect(
        () => CourseModel.fromJson({
          'id': 'x',
          'sections': [
            {
              'id': 's',
              'lessons': [
                {'title': 'no id'},
              ],
            },
          ],
        }),
        throwsFormatException,
      );
    });
  });
}
