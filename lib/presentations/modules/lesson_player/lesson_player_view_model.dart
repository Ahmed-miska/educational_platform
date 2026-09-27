import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import '../../../core/navigator/navigator.dart';
import '../../../core/resources/app_translate.dart';
import '../../../core/utils/functions.dart';
import '../../../data/datasource/local/local_user_data.dart';
import '../../../data/models/course_model.dart';
import '../../../data/models/lesson_model.dart';
import '../../../domain/progress_rules.dart';
import '../../../injection.dart';
import '../progress_view_model.dart';

class LessonPlayerViewModel with ChangeNotifier, WidgetsBindingObserver {
  static const Duration _saveInterval = Duration(seconds: 5);
  static const Duration _hideControlsDelay = Duration(seconds: 3);
  static const Duration _seekStep = Duration(seconds: 10);

  final ProgressViewModel _progressViewModel;
  final LocalUserData _localUserData;

  LessonPlayerViewModel({required this.course, required this.lesson, ProgressViewModel? progressViewModel, LocalUserData? localUserData})
    : _progressViewModel = progressViewModel ?? getIt(),
      _localUserData = localUserData ?? getIt() {
    _playbackSpeed = _localUserData.getPlaybackSpeed();
    WidgetsBinding.instance.addObserver(this);
    _loadVideo();
  }

  final CourseModel course;
  final LessonModel lesson;

  VideoPlayerController? _controller;
  bool _isError = false;
  bool _isFullScreen = false;
  bool _isDisposed = false;
  bool _wasPlaying = false;
  bool _isControlsVisible = true;
  Timer? _hideControlsTimer;
  double? _dragPositionMs;
  late double _playbackSpeed;
  Duration _lastSavedPosition = Duration.zero;

  VideoPlayerController? get controller => _controller;
  VideoPlayerValue get _value => _controller?.value ?? const VideoPlayerValue.uninitialized();
  bool get isLoading => _controller == null;
  bool get isError => _isError;
  bool get isFullScreen => _isFullScreen;
  double get playbackSpeed => _playbackSpeed;
  double get aspectRatio => _value.aspectRatio;

  LessonModel? get nextLesson => course.lessonAfter(lesson.id);
  bool get isLessonCompleted => _progressViewModel.isCompleted(lesson.id);
  bool get canOpenNextLesson => nextLesson != null && _progressViewModel.isUnlocked(course, nextLesson!.id);

  String subtitle(String languageCode) {
    final sectionTitle = course.sectionOf(lesson.id)?.title.of(languageCode) ?? '';
    return '$sectionTitle · ${AppTranslate.lessonOf(course.lessonNumber(lesson.id), course.lessons.length)}';
  }

  String nextLessonTitle(String languageCode) => '${AppTranslate.nextLesson}: ${nextLesson?.title.of(languageCode) ?? ''}';

  String get finishLessonFirstMessage => AppTranslate.finishLessonFirst((ProgressRules.completionThreshold * 100).round());

  bool get isControlsVisible => _isControlsVisible || !_value.isPlaying;
  double get durationMs => math.max(_value.duration.inMilliseconds, 1).toDouble();
  double get sliderPositionMs => (_dragPositionMs ?? _value.position.inMilliseconds.toDouble()).clamp(0.0, durationMs);
  Duration get sliderPosition => Duration(milliseconds: sliderPositionMs.round());
  Duration get videoDuration => _value.duration;

  IconData get playIcon {
    if (_value.isCompleted) return Icons.replay_rounded;
    return _value.isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded;
  }

  String get playTooltip {
    if (_value.isCompleted) return AppTranslate.replay;
    return _value.isPlaying ? AppTranslate.pause : AppTranslate.play;
  }

  String speedLabel(double speed) => '${speed == speed.roundToDouble() ? speed.toInt() : speed}x';

  Future<void> _loadVideo() async {
    _isError = false;
    notifyListeners();

    final controller = VideoPlayerController.asset(lesson.video);
    try {
      await controller.initialize();
      final saved = _progressViewModel.progressOf(lesson.id)?.position ?? Duration.zero;
      final start = ProgressRules.resumePosition(saved: saved, duration: controller.value.duration);
      await controller.seekTo(start);
      await controller.setPlaybackSpeed(_playbackSpeed);
      _lastSavedPosition = start;
    } catch (e) {
      debugPrint('Failed to load ${lesson.video}: $e');
      await controller.dispose();
      if (_isDisposed) return;
      _isError = true;
      notifyListeners();
      return;
    }

    if (_isDisposed) {
      await controller.dispose();
      return;
    }
    controller.addListener(_onPlayerValueChanged);
    _controller = controller;
    _isControlsVisible = true;
    notifyListeners();
    hideControlsLater();
    await controller.play();
  }

  void _onPlayerValueChanged() {
    final value = _controller!.value;
    if (value.hasError) {
      if (!_isError) {
        _isError = true;
        notifyListeners();
      }
      return;
    }

    final crossedCompletion = !isLessonCompleted && ProgressRules.reachedCompletion(position: value.position, duration: value.duration);
    final justPaused = _wasPlaying && !value.isPlaying;
    _wasPlaying = value.isPlaying;
    if (crossedCompletion || justPaused || (value.position - _lastSavedPosition).abs() >= _saveInterval) {
      _saveProgress();
    }
  }

  Future<void> _saveProgress() async {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    final position = controller.value.position;
    _lastSavedPosition = position;
    final justCompleted = await _progressViewModel.savePosition(
      courseId: course.id,
      lessonId: lesson.id,
      position: position,
      duration: controller.value.duration,
    );
    if (justCompleted && !_isDisposed) showMessage(AppTranslate.lessonCompleted);
  }

  void toggleControls() {
    _isControlsVisible = !_isControlsVisible;
    notifyListeners();
    if (_isControlsVisible) hideControlsLater();
  }

  void keepControlsVisible() => _hideControlsTimer?.cancel();

  void hideControlsLater() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(_hideControlsDelay, () {
      if (_value.isPlaying && _dragPositionMs == null) {
        _isControlsVisible = false;
        notifyListeners();
      }
    });
  }

  Future<void> togglePlay() async {
    hideControlsLater();
    final controller = _controller;
    if (controller == null) return;
    if (controller.value.isPlaying) {
      await controller.pause();
    } else {
      if (controller.value.isCompleted) await controller.seekTo(Duration.zero);
      await controller.play();
    }
  }

  Future<void> rewind() => _seekTo(_value.position - _seekStep);

  Future<void> forward() => _seekTo(_value.position + _seekStep);

  void onSeekStart(double positionMs) {
    _hideControlsTimer?.cancel();
    _dragPositionMs = positionMs;
    notifyListeners();
  }

  void onSeekUpdate(double positionMs) {
    _dragPositionMs = positionMs;
    notifyListeners();
  }

  Future<void> onSeekEnd(double positionMs) async {
    await _seekTo(Duration(milliseconds: positionMs.round()));
    _dragPositionMs = null;
    notifyListeners();
  }

  Future<void> _seekTo(Duration position) async {
    hideControlsLater();
    final controller = _controller;
    if (controller == null) return;
    final duration = controller.value.duration;
    await controller.seekTo(position < Duration.zero ? Duration.zero : (position > duration ? duration : position));
    await _saveProgress();
  }

  Future<void> setPlaybackSpeed(double speed) async {
    hideControlsLater();
    _playbackSpeed = speed;
    notifyListeners();
    await _controller?.setPlaybackSpeed(speed);
    await _localUserData.savePlaybackSpeed(speed);
  }

  Future<void> retry() async {
    final old = _controller;
    _controller = null;
    if (old != null) {
      old.removeListener(_onPlayerValueChanged);
      await old.dispose();
    }
    await _loadVideo();
  }

  void openNextLesson() {
    if (canOpenNextLesson) {
      NavigatorHandler.replaceWithLesson(course.id, nextLesson!.id);
    } else {
      showMessage(finishLessonFirstMessage);
    }
  }

  void onPopInvoked(bool didPop, Object? result) {
    if (!didPop) _exitFullScreen();
  }

  Future<void> toggleFullScreen() {
    hideControlsLater();
    return _isFullScreen ? _exitFullScreen() : _enterFullScreen();
  }

  Future<void> _enterFullScreen() async {
    _isFullScreen = true;
    notifyListeners();
    await SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  Future<void> _exitFullScreen() async {
    _isFullScreen = false;
    notifyListeners();
    await _restoreSystemUi();
  }

  static Future<void> _restoreSystemUi() async {
    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        _saveProgress();
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        _controller?.pause();
      case AppLifecycleState.resumed:
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void notifyListeners() {
    if (!_isDisposed) super.notifyListeners();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _hideControlsTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    final controller = _controller;
    if (controller != null) {
      controller.removeListener(_onPlayerValueChanged);
      if (controller.value.isInitialized) {
        _progressViewModel.savePosition(
          courseId: course.id,
          lessonId: lesson.id,
          position: controller.value.position,
          duration: controller.value.duration,
        );
      }
      controller.dispose();
    }
    if (_isFullScreen) _restoreSystemUi();
    super.dispose();
  }
}
