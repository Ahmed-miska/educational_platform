import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/app_theme/theme_manager.dart';
import 'injection.dart';
import 'presentations/modules/courses/courses_view_model.dart';
import 'presentations/modules/progress_view_model.dart';

class GenerateMultiProviders extends StatelessWidget {
  final Widget child;

  const GenerateMultiProviders({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeManager>.value(value: getIt<ThemeManager>()),
        ChangeNotifierProvider<CoursesViewModel>.value(value: getIt<CoursesViewModel>()),
        ChangeNotifierProvider<ProgressViewModel>.value(value: getIt<ProgressViewModel>()),
      ],
      child: child,
    );
  }
}
