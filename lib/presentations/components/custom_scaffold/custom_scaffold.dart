import 'package:flutter/material.dart';

import '../../../core/app_theme/colors_theme.dart';

class CustomScaffold extends StatelessWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;

  const CustomScaffold({super.key, this.appBar, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bodyBG(context),
      appBar: appBar,
      body: SafeArea(top: appBar == null, child: body),
    );
  }
}
