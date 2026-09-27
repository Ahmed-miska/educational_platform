import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/app_theme/theme_manager.dart';
import 'data/datasource/local/courses_local_data_source.dart';
import 'data/datasource/local/local_user_data.dart';
import 'data/datasource/local/progress_local_data.dart';
import 'data/repos/courses_repository.dart';
import 'data/repos/progress_repository.dart';
import 'presentations/modules/courses/courses_view_model.dart';
import 'presentations/modules/lesson_player/lesson_player_view_model.dart';
import 'presentations/modules/progress_view_model.dart';

final getIt = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton(() => sharedPreferences);

  getIt.registerLazySingleton(() => LocalUserData());
  getIt.registerLazySingleton(() => ProgressLocalData());
  getIt.registerLazySingleton(() => CoursesLocalDataSource());

  getIt.registerLazySingleton(() => CoursesRepository());
  getIt.registerLazySingleton(() => ProgressRepository());

  getIt.registerLazySingleton(() => ThemeManager());
  getIt.registerLazySingleton(() => CoursesViewModel());
  getIt.registerLazySingleton(() => ProgressViewModel());
  getIt.registerFactory(() => LessonPlayerViewModel());
}
