import 'package:flutter/material.dart';

import '../../../core/app_theme/colors_theme.dart';
import '../../../core/resources/font_size.dart';
import '../custom_text/custom_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool isBackButtonExist;

  const CustomAppBar({super.key, this.title, this.actions, this.isBackButtonExist = true});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bodyBG(context),
      automaticallyImplyLeading: false,
      leading: isBackButtonExist ? const BackButton() : null,
      titleSpacing: isBackButtonExist ? 0 : null,
      title: CustomText(title: title, fontSize: AppFonts.font18, fontWeight: FontWeight.w700, maxLines: 1),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
