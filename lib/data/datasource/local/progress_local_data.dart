import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/constants.dart';
import '../../../injection.dart';
import '../../models/lesson_progress_model.dart';

class ProgressLocalData {
  final SharedPreferences _sharedPreferences;

  ProgressLocalData({SharedPreferences? sharedPreferences}) : _sharedPreferences = sharedPreferences ?? getIt();

  Map<String, LessonProgressModel> getAll() {
    final raw = _sharedPreferences.getString(localLessonsProgress);
    if (raw == null) return {};
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return decoded.map((key, value) => MapEntry(key, LessonProgressModel.fromJson(value as Map<String, dynamic>)));
    } catch (e) {
      debugPrint('Ignoring corrupt lesson progress: $e');
      return {};
    }
  }

  Future<void> saveAll(Map<String, LessonProgressModel> progress) async {
    final encoded = jsonEncode(progress.map((key, value) => MapEntry(key, value.toJson())));
    await _sharedPreferences.setString(localLessonsProgress, encoded);
  }

  Future<void> clear() => _sharedPreferences.remove(localLessonsProgress);
}
