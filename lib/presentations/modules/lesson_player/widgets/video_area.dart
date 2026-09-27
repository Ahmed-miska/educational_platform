import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/resources/app_translate.dart';
import '../../../components/error/custom_error_widget.dart';
import '../../../components/loadings/loading_indicator.dart';
import '../lesson_player_view_model.dart';
import 'player_controls.dart';

class VideoArea extends StatelessWidget {
  const VideoArea({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: Colors.black,
      child: Consumer<LessonPlayerViewModel>(
        builder: (context, viewModel, child) {
          if (viewModel.isError) {
            return CustomErrorWidget(
              message: AppTranslate.videoError,
              icon: Icons.videocam_off_outlined,
              color: Colors.white,
              onRetry: viewModel.retry,
            );
          }
          if (viewModel.isLoading) {
            return const LoadingIndicator(color: Colors.white);
          }
          return Center(
            child: AspectRatio(
              aspectRatio: viewModel.aspectRatio,
              child: Stack(fit: StackFit.expand, children: [VideoPlayer(viewModel.controller!), const PlayerControls()]),
            ),
          );
        },
      ),
    );
  }
}
