import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/resources/app_translate.dart';
import '../../../components/custom_app_bar/custom_app_bar.dart';
import '../../../components/custom_scaffold/custom_scaffold.dart';
import '../lesson_player_view_model.dart';
import 'lesson_info.dart';
import 'video_area.dart';

class LessonPlayerView extends StatelessWidget {
  const LessonPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final languageCode = AppTranslate.languageCode(context);
    return Consumer<LessonPlayerViewModel>(
      builder: (context, viewModel, child) {
        return PopScope(
          canPop: !viewModel.isFullScreen,
          onPopInvokedWithResult: viewModel.onPopInvoked,
          child: viewModel.isFullScreen
              ? const Scaffold(backgroundColor: Colors.black, body: VideoArea())
              : CustomScaffold(
                  appBar: CustomAppBar(title: viewModel.lesson.title.of(languageCode)),
                  body: ListView(
                    children: [
                      const AspectRatio(aspectRatio: 16 / 9, child: VideoArea()),
                      LessonInfo(languageCode: languageCode),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
