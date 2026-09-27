import 'package:flutter/foundation.dart';

import '../../injection.dart';
import '../data_response.dart';
import '../datasource/local/courses_local_data_source.dart';
import '../models/course_model.dart';

class CoursesRepository {
  final CoursesLocalDataSource _dataSource;

  CoursesRepository({CoursesLocalDataSource? dataSource}) : _dataSource = dataSource ?? getIt();

  Future<DataResponse<List<CourseModel>>> getCourses() async {
    try {
      return DataResponse.withSuccess(await _dataSource.loadCourses());
    } catch (e) {
      debugPrint('Failed to load courses: $e');
      return DataResponse.withError(e);
    }
  }
}
