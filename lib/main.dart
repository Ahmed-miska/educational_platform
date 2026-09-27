import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'core/app_theme/theme.dart';
import 'core/app_theme/theme_manager.dart';
import 'core/constants/constants.dart';
import 'core/navigator/app_router.dart';
import 'core/resources/app_assets.dart';
import 'core/resources/app_translate.dart';
import 'core/utils/functions.dart';
import 'injection.dart';
import 'multiproviders.dart';
import 'presentations/modules/courses/courses_view_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await init();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  getIt<CoursesViewModel>().getCourses();

  runApp(
    GenerateMultiProviders(
      child: EasyLocalization(
        supportedLocales: supportedLocales,
        path: AppAssets.languagesPath,
        startLocale: supportedLocales.first,
        fallbackLocale: supportedLocales.first,
        saveLocale: true,
        useOnlyLangCode: true,
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeManager>(
      builder: (context, themeManager, child) {
        return MaterialApp.router(
          onGenerateTitle: (context) => context.tr('appName'),
          debugShowCheckedModeBanner: false,
          scaffoldMessengerKey: scaffoldMessengerKey,
          routerConfig: appRouter,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
          themeMode: themeManager.themeMode,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          builder: (context, child) {
            AppTranslate.init(context);
            return child!;
          },
        );
      },
    );
  }
}
