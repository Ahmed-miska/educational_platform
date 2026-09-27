import 'package:flutter/material.dart';

import '../../../../core/dimens/dimens.dart';
import '../../../../core/resources/app_translate.dart';
import '../../../../core/resources/font_size.dart';
import '../../../../core/utils/functions.dart';
import '../../../../core/app_theme/app_colors.dart';
import '../../../../data/models/continue_watching_model.dart';
import '../../../components/custom_text/custom_text.dart';
import '../../../components/progress/app_progress_bar.dart';

class ContinueWatchingCard extends StatelessWidget {
  final ContinueWatchingModel item;
  final String languageCode;
  final VoidCallback onTap;

  const ContinueWatchingCard({super.key, required this.item, required this.languageCode, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.mainColor(context),
      borderRadius: BorderRadius.circular(Dimens.radius16),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(Dimens.padding16),
          child: Row(
            spacing: Dimens.padding12,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: Dimens.padding6,
                  children: [
                    CustomText(
                      title: AppTranslate.continueWatching,
                      fontSize: AppFonts.font12,
                      fontColor: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                    CustomText(
                      title: item.lesson.title.of(languageCode),
                      fontSize: AppFonts.font18,
                      fontColor: Colors.white,
                      fontWeight: FontWeight.w700,
                      maxLines: 1,
                    ),
                    CustomText(title: item.course.title.of(languageCode), fontSize: AppFonts.font13, fontColor: Colors.white70, maxLines: 1),
                    const SizedBox(height: Dimens.padding4),
                    AppProgressBar(value: item.watchedFraction, color: Colors.white),
                    CustomText(title: AppTranslate.timeLeft(formatDuration(item.timeLeft)), fontSize: AppFonts.font12, fontColor: Colors.white70),
                  ],
                ),
              ),
              const CircleAvatar(
                radius: 26,
                backgroundColor: Colors.white,
                child: Icon(Icons.play_arrow_rounded, size: 32, color: Colors.black87),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
