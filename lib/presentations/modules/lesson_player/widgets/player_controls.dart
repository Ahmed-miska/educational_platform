import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/constants/constants.dart';
import '../../../../core/dimens/dimens.dart';
import '../../../../core/resources/app_translate.dart';
import '../../../../core/resources/font_size.dart';
import '../../../../core/utils/functions.dart';
import '../../../components/custom_text/custom_text.dart';
import '../lesson_player_view_model.dart';

class PlayerControls extends StatelessWidget {
  const PlayerControls({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<LessonPlayerViewModel>(
      builder: (context, viewModel, child) {
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: viewModel.toggleControls,
          child: Directionality(
            textDirection: TextDirection.ltr,
            child: ValueListenableBuilder<VideoPlayerValue>(
              valueListenable: viewModel.controller!,
              builder: (context, _, _) {
                return AnimatedOpacity(
                  opacity: viewModel.isControlsVisible ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    ignoring: !viewModel.isControlsVisible,
                    child: DecoratedBox(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.black26, Colors.transparent, Colors.black87],
                        ),
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              spacing: Dimens.padding24,
                              children: [
                                IconButton(
                                  tooltip: AppTranslate.rewind10,
                                  iconSize: 36,
                                  color: Colors.white,
                                  icon: const Icon(Icons.replay_10_rounded),
                                  onPressed: viewModel.rewind,
                                ),
                                IconButton(
                                  tooltip: viewModel.playTooltip,
                                  iconSize: 56,
                                  color: Colors.white,
                                  icon: Icon(viewModel.playIcon),
                                  onPressed: viewModel.togglePlay,
                                ),
                                IconButton(
                                  tooltip: AppTranslate.forward10,
                                  iconSize: 36,
                                  color: Colors.white,
                                  icon: const Icon(Icons.forward_10_rounded),
                                  onPressed: viewModel.forward,
                                ),
                              ],
                            ),
                          ),
                          Positioned(
                            left: 0,
                            right: 0,
                            bottom: 0,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: Dimens.padding8),
                              child: Row(
                                children: [
                                  CustomText(
                                    title: formatDuration(viewModel.sliderPosition),
                                    fontColor: Colors.white,
                                    fontSize: AppFonts.font12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  Expanded(
                                    child: SliderTheme(
                                      data: SliderTheme.of(context).copyWith(
                                        trackHeight: 3,
                                        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
                                        overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                                        activeTrackColor: Colors.white,
                                        inactiveTrackColor: Colors.white30,
                                        thumbColor: Colors.white,
                                      ),
                                      child: Slider(
                                        value: viewModel.sliderPositionMs,
                                        max: viewModel.durationMs,
                                        onChangeStart: viewModel.onSeekStart,
                                        onChanged: viewModel.onSeekUpdate,
                                        onChangeEnd: viewModel.onSeekEnd,
                                      ),
                                    ),
                                  ),
                                  CustomText(
                                    title: formatDuration(viewModel.videoDuration),
                                    fontColor: Colors.white,
                                    fontSize: AppFonts.font12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                  PopupMenuButton<double>(
                                    tooltip: AppTranslate.playbackSpeed,
                                    initialValue: viewModel.playbackSpeed,
                                    onOpened: viewModel.keepControlsVisible,
                                    onCanceled: viewModel.hideControlsLater,
                                    onSelected: viewModel.setPlaybackSpeed,
                                    itemBuilder: (_) => [
                                      for (final speed in playbackSpeeds) PopupMenuItem(value: speed, child: Text(viewModel.speedLabel(speed))),
                                    ],
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: Dimens.padding8, vertical: Dimens.padding12),
                                      child: CustomText(
                                        title: viewModel.speedLabel(viewModel.playbackSpeed),
                                        fontColor: Colors.white,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  IconButton(
                                    tooltip: viewModel.isFullScreen ? AppTranslate.exitFullScreen : AppTranslate.fullScreen,
                                    iconSize: 28,
                                    color: Colors.white,
                                    icon: Icon(viewModel.isFullScreen ? Icons.fullscreen_exit_rounded : Icons.fullscreen_rounded),
                                    onPressed: viewModel.toggleFullScreen,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
