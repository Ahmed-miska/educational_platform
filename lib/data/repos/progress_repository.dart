import '../../injection.dart';
import '../datasource/local/progress_local_data.dart';
import '../models/lesson_progress_model.dart';

class ProgressRepository {
  final ProgressLocalData _localData;

  ProgressRepository({ProgressLocalData? localData}) : _localData = localData ?? getIt();

  Map<String, LessonProgressModel> getAllProgress() => _localData.getAll();

  Future<void> saveAllProgress(Map<String, LessonProgressModel> progress) => _localData.saveAll(progress);

  Future<void> clearProgress() => _localData.clear();
}
