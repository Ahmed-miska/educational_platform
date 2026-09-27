import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AppTranslate {
  AppTranslate._();

  static BuildContext? _context;

  static void init(BuildContext context) {
    _context = context;
  }

  static String _tr(String key, {List<String>? args}) {
    return _context != null ? _context!.tr(key, args: args) : key;
  }

  static String languageCode(BuildContext context) => EasyLocalization.of(context)?.locale.languageCode ?? 'ar';

  static String get myCourses => _tr('myCourses');
  static String get searchCourses => _tr('searchCourses');
  static String get continueWatching => _tr('continueWatching');
  static String timeLeft(String time) => _tr('timeLeft', args: [time]);
  static String get allCourses => _tr('allCourses');
  static String lessonsCount(int count) => _context != null ? _context!.plural('lessonsCount', count) : '$count';
  static String completedPercent(int percent) => _tr('completedPercent', args: ['$percent']);
  static String get courseCompleted => _tr('courseCompleted');
  static String get noCourses => _tr('noCourses');
  static String noSearchResults(String query) => _tr('noSearchResults', args: [query]);
  static String get coursesLoadError => _tr('coursesLoadError');
  static String get tryAgain => _tr('tryAgain');
  static String get courseNotFound => _tr('courseNotFound');
  static String get lessonNotFound => _tr('lessonNotFound');
  static String get noLessonsYet => _tr('noLessonsYet');
  static String get noLessonsInSection => _tr('noLessonsInSection');
  static String get statusNotStarted => _tr('statusNotStarted');
  static String get statusInProgress => _tr('statusInProgress');
  static String get statusCompleted => _tr('statusCompleted');
  static String get statusLocked => _tr('statusLocked');
  static String lessonLockedMessage(String previousLesson) => _tr('lessonLockedMessage', args: [previousLesson]);
  static String get lessonLockedTitle => _tr('lessonLockedTitle');
  static String get nextLesson => _tr('nextLesson');
  static String finishLessonFirst(int percent) => _tr('finishLessonFirst', args: ['$percent']);
  static String get lastLesson => _tr('lastLesson');
  static String get courseFinished => _tr('courseFinished');
  static String get lessonCompleted => _tr('lessonCompleted');
  static String lessonOf(int number, int total) => _tr('lessonOf', args: ['$number', '$total']);
  static String get videoError => _tr('videoError');
  static String get playbackSpeed => _tr('playbackSpeed');
  static String get fullScreen => _tr('fullScreen');
  static String get exitFullScreen => _tr('exitFullScreen');
  static String get play => _tr('play');
  static String get pause => _tr('pause');
  static String get replay => _tr('replay');
  static String get rewind10 => _tr('rewind10');
  static String get forward10 => _tr('forward10');
  static String get settings => _tr('settings');
  static String get language => _tr('language');
  static String get darkMode => _tr('darkMode');
  static String get resetProgress => _tr('resetProgress');
  static String get resetProgressConfirm => _tr('resetProgressConfirm');
  static String get progressCleared => _tr('progressCleared');
  static String get cancel => _tr('cancel');
  static String get confirm => _tr('confirm');
  static String get pageNotFound => _tr('pageNotFound');
}
