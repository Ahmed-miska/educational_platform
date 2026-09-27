import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/constants.dart';
import '../../../injection.dart';

class LocalUserData {
  final SharedPreferences _sharedPreferences;

  LocalUserData({SharedPreferences? sharedPreferences}) : _sharedPreferences = sharedPreferences ?? getIt();

  Future<void> saveThemeMode(ThemeMode mode) => _sharedPreferences.setString(localThemeMode, mode.name);

  ThemeMode getThemeMode() {
    final saved = _sharedPreferences.getString(localThemeMode);
    return ThemeMode.values.firstWhere((e) => e.name == saved, orElse: () => ThemeMode.system);
  }

  Future<void> savePlaybackSpeed(double speed) => _sharedPreferences.setDouble(localPlaybackSpeed, speed);

  double getPlaybackSpeed() {
    final saved = _sharedPreferences.getDouble(localPlaybackSpeed);
    return playbackSpeeds.contains(saved) ? saved! : 1.0;
  }
}
