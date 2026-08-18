import 'package:workout_record_app/domain/entities/training_log.dart';
import 'package:workout_record_app/domain/repositories/training_log_repository.dart';
import 'package:workout_record_app/domain/validation/training_log_validator.dart';

/// トレ記録保存ユースケース（FR-REC-001）。
class SaveTrainingLogUseCase {
  SaveTrainingLogUseCase({
    required TrainingLogRepository repository,
    TrainingLogValidator validator = const TrainingLogValidator(),
  })  : _repository = repository,
        _validator = validator;

  final TrainingLogRepository _repository;
  final TrainingLogValidator _validator;

  Future<({TrainingLog? log, String? error})> execute({
    int? menuId,
    required double weightKg,
    required int reps,
    required DateTime trainedOn,
    required DateTime now,
  }) async {
    final validation = _validator.validate(
      menuId: menuId,
      weightKg: weightKg,
      reps: reps,
      trainedOn: trainedOn,
      today: now,
    );
    if (validation is ValidationFailure) {
      return (log: null, error: validation.message);
    }

    final trainedOnStr = _formatDate(trainedOn);
    final createdAt = now.toUtc().toIso8601String();
    final roundedWeight = (weightKg * 100).round() / 100;

    final log = await _repository.insert(
      menuId: menuId!,
      trainedOn: trainedOnStr,
      weightKg: roundedWeight,
      reps: reps,
      createdAt: createdAt,
    );
    return (log: log, error: null);
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
