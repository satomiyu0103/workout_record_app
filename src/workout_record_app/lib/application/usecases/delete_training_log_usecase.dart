import 'package:workout_record_app/domain/repositories/training_log_repository.dart';

/// トレ記録削除ユースケース（FR-REC-003・冪等削除）。
class DeleteTrainingLogUseCase {
  DeleteTrainingLogUseCase({required TrainingLogRepository repository})
      : _repository = repository;

  final TrainingLogRepository _repository;

  Future<void> execute(int logId) async {
    if (await _repository.existsById(logId)) {
      await _repository.deleteById(logId);
    }
  }
}
