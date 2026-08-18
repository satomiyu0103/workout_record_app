import 'package:workout_record_app/domain/entities/previous_session.dart';
import 'package:workout_record_app/domain/entities/training_log.dart';

/// トレーニング記録のリポジトリ抽象。
abstract class TrainingLogRepository {
  Future<TrainingLog> insert({
    required int menuId,
    required String trainedOn,
    required double weightKg,
    required int reps,
    required String createdAt,
  });

  Future<List<TrainingLog>> listByDateAndMenu({
    required String trainedOn,
    required int menuId,
  });

  Future<List<TrainingLog>> listByMenu(int menuId);

  Future<Set<String>> listRecordedDates({int? year, int? month});

  Future<void> deleteById(int logId);

  Future<bool> existsById(int logId);

  Future<PreviousSession> findPreviousSession({
    required int menuId,
    required String beforeTrainedOn,
  });
}
