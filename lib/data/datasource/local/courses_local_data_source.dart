import 'dart:convert';

import 'package:flutter/services.dart';

import '../../../core/resources/app_assets.dart';
import '../../models/course_model.dart';

class CoursesLocalDataSource {
  final AssetBundle _bundle;

  CoursesLocalDataSource({AssetBundle? bundle}) : _bundle = bundle ?? rootBundle;

  Future<List<CourseModel>> loadCourses() async {
    final raw = await _bundle.loadString(AppAssets.coursesJson);
    final decoded = jsonDecode(raw);
    if (decoded is! Map<String, dynamic> || decoded['courses'] is! List) {
      throw const FormatException('courses.json must contain a "courses" list');
    }
    return (decoded['courses'] as List).map((e) => CourseModel.fromJson(e as Map<String, dynamic>)).toList();
  }
}
