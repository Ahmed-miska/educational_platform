import 'package:educational_platform/data/datasource/local/courses_local_data_source.dart';
import 'package:educational_platform/data/models/course_model.dart';
import 'package:educational_platform/data/models/lesson_model.dart';
import 'package:educational_platform/data/models/localized_text.dart';
import 'package:educational_platform/data/models/section_model.dart';

LessonModel lesson(String id, {int durationSec = 60}) => LessonModel(
  id: id,
  title: LocalizedText(ar: 'درس $id', en: 'Lesson $id'),
  durationSec: durationSec,
  video: 'assets/videos/$id.mp4',
);

CourseModel testCourse() => CourseModel(
  id: 'c1',
  title: const LocalizedText(ar: 'مقدمة في التشريح', en: 'Intro to Anatomy'),
  instructor: const LocalizedText(ar: 'د. سارة', en: 'Dr. Sarah'),
  thumbnail: '',
  sections: [
    SectionModel(
      id: 's1',
      title: const LocalizedText(ar: 'القسم الأول'),
      lessons: [lesson('l1'), lesson('l2')],
    ),
    SectionModel(
      id: 's2',
      title: const LocalizedText(ar: 'القسم الثاني'),
      lessons: [lesson('l3')],
    ),
  ],
);

CourseModel emptyCourse() => CourseModel(
  id: 'empty',
  title: const LocalizedText(ar: 'علم الأدوية', en: 'Pharmacology'),
  instructor: const LocalizedText(ar: 'د. ليلى'),
  thumbnail: '',
  sections: const [],
);

class FakeCoursesDataSource extends CoursesLocalDataSource {
  final List<CourseModel> courses;
  final bool fail;

  FakeCoursesDataSource(this.courses, {this.fail = false});

  @override
  Future<List<CourseModel>> loadCourses() async {
    if (fail) throw const FormatException('corrupt');
    return courses;
  }
}
