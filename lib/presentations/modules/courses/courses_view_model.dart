import 'package:flutter/widgets.dart';

import '../../../core/navigator/navigator.dart';
import '../../../core/utils/text_normalizer.dart';
import '../../../data/models/continue_watching_model.dart';
import '../../../data/models/course_model.dart';
import '../../../data/repos/courses_repository.dart';
import '../../../injection.dart';
import '../progress_view_model.dart';

class CoursesViewModel with ChangeNotifier {
  final CoursesRepository _coursesRepository;
  final ProgressViewModel _progressViewModel;

  CoursesViewModel({CoursesRepository? coursesRepository, ProgressViewModel? progressViewModel})
    : _coursesRepository = coursesRepository ?? getIt(),
      _progressViewModel = progressViewModel ?? getIt();

  final TextEditingController searchController = TextEditingController();
  List<CourseModel> _courses = [];
  bool _isLoading = false;
  bool _isError = false;
  bool _hasLoaded = false;

  List<CourseModel> get courses => _courses;
  bool get isError => _isError;
  bool get hasLoaded => _hasLoaded;
  String get searchQuery => searchController.text.trim();
  bool get isSearching => searchQuery.isNotEmpty;
  bool get hasSearchText => searchController.text.isNotEmpty;

  List<CourseModel> get filteredCourses {
    final query = normalizeForSearch(searchQuery);
    if (query.isEmpty) return _courses;
    return _courses
        .where((course) => [...course.title.values, ...course.instructor.values].any((text) => normalizeForSearch(text).contains(query)))
        .toList();
  }

  ContinueWatchingModel? get continueWatching {
    if (isSearching) return null;
    final progress = _progressViewModel.continueWatching(_courses);
    if (progress == null) return null;
    final course = courseById(progress.courseId)!;
    return ContinueWatchingModel(course: course, lesson: course.lessonById(progress.lessonId)!, progress: progress);
  }

  CourseModel? courseById(String id) {
    for (final course in _courses) {
      if (course.id == id) return course;
    }
    return null;
  }

  Future<void> getCourses() async {
    if (_isLoading) return;
    _isLoading = true;
    _isError = false;
    notifyListeners();

    final response = await _coursesRepository.getCourses();
    if (response.isSuccess) {
      _courses = response.data!;
      _hasLoaded = true;
    } else {
      _isError = true;
    }

    _isLoading = false;
    notifyListeners();
  }

  void onSearchChanged(String text) => notifyListeners();

  void clearSearch() {
    searchController.clear();
    notifyListeners();
  }

  void openContinueWatching() {
    final item = continueWatching;
    if (item != null) NavigatorHandler.openLesson(item.course.id, item.lesson.id);
  }
}
