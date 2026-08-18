import 'package:workout_record_app/domain/entities/daily_profile.dart';
import 'package:workout_record_app/domain/repositories/daily_profile_repository.dart';

class SaveDailyProfileResult {
  const SaveDailyProfileResult({this.profile, this.error});

  final DailyProfile? profile;
  final String? error;
}

/// 日次の体組成・健康記録を保存する。
class SaveDailyProfileUseCase {
  SaveDailyProfileUseCase({required DailyProfileRepository repository})
      : _repository = repository;

  final DailyProfileRepository _repository;

  Future<SaveDailyProfileResult> execute({
    required String date,
    double? heightCm,
    double? weightKg,
    int? bloodPressureSystolic,
    int? bloodPressureDiastolic,
    required DateTime now,
  }) async {
    if (heightCm == null &&
        weightKg == null &&
        bloodPressureSystolic == null &&
        bloodPressureDiastolic == null) {
      return const SaveDailyProfileResult(error: '1つ以上の値を入力してください');
    }

    if (heightCm != null && (heightCm <= 0 || heightCm > 300)) {
      return const SaveDailyProfileResult(error: '身長は 0〜300 cm の範囲で入力してください');
    }

    if (weightKg != null && (weightKg <= 0 || weightKg > 500)) {
      return const SaveDailyProfileResult(error: '体重は 0〜500 kg の範囲で入力してください');
    }

    if (bloodPressureSystolic != null &&
        (bloodPressureSystolic < 50 || bloodPressureSystolic > 300)) {
      return const SaveDailyProfileResult(
        error: '収縮期血圧は 50〜300 の範囲で入力してください',
      );
    }

    if (bloodPressureDiastolic != null &&
        (bloodPressureDiastolic < 30 || bloodPressureDiastolic > 200)) {
      return const SaveDailyProfileResult(
        error: '拡張期血圧は 30〜200 の範囲で入力してください',
      );
    }

    final profile = DailyProfile(
      date: date,
      heightCm: heightCm,
      weightKg: weightKg,
      bloodPressureSystolic: bloodPressureSystolic,
      bloodPressureDiastolic: bloodPressureDiastolic,
      updatedAt: now.toUtc().toIso8601String(),
    );

    final saved = await _repository.upsert(profile);
    return SaveDailyProfileResult(profile: saved);
  }
}
