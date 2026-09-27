import 'package:flutter/widgets.dart';

import '../../data/models/app_language.dart';

const String localThemeMode = 'localThemeMode';
const String localPlaybackSpeed = 'localPlaybackSpeed';
const String localLessonsProgress = 'localLessonsProgress';

const List<AppLanguage> appLanguage = [AppLanguage('العربية', 'ar'), AppLanguage('English', 'en')];

List<Locale> get supportedLocales => appLanguage.map((e) => Locale(e.languageCode)).toList();

const List<double> playbackSpeeds = [1.0, 1.25, 1.5, 2.0];
