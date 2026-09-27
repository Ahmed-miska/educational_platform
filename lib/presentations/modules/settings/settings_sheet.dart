import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_theme/app_colors.dart';
import '../../../core/app_theme/theme_manager.dart';
import '../../../core/constants/constants.dart';
import '../../../core/dimens/dimens.dart';
import '../../../core/resources/app_translate.dart';
import '../../../core/resources/font_size.dart';
import '../../components/custom_text/custom_text.dart';
import 'widgets/reset_progress_dialog.dart';

class SettingsSheet extends StatelessWidget {
  const SettingsSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: AppColors.white(context),
      builder: (_) => const SettingsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final languageCode = AppTranslate.languageCode(context);
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(Dimens.padding16, 0, Dimens.padding16, Dimens.padding16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: Dimens.padding12,
              children: [
                CustomText(title: AppTranslate.settings, fontSize: AppFonts.font18, fontWeight: FontWeight.w700),
                CustomText(title: AppTranslate.language, fontColor: AppColors.gray(context)),
                SegmentedButton<String>(
                  showSelectedIcon: false,
                  segments: [for (final language in appLanguage) ButtonSegment(value: language.languageCode, label: Text(language.title))],
                  selected: {languageCode},
                  onSelectionChanged: (selection) => context.setLocale(Locale(selection.first)),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: CustomText(title: AppTranslate.darkMode),
                  secondary: const Icon(Icons.dark_mode_outlined),
                  value: themeManager.isDarkMode(context),
                  onChanged: themeManager.toggleTheme,
                ),
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: Icon(Icons.restart_alt_rounded, color: AppColors.error),
                  title: CustomText(title: AppTranslate.resetProgress, fontColor: AppColors.error),
                  onTap: () => showDialog(context: context, builder: (_) => const ResetProgressDialog()),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
