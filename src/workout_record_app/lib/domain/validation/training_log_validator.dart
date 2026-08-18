/// 記録保存バリデーションの結果。
sealed class ValidationResult {
  const ValidationResult();
}

class ValidationSuccess extends ValidationResult {
  const ValidationSuccess();
}

class ValidationFailure extends ValidationResult {
  const ValidationFailure(this.message);

  final String message;
}

/// 記録保存の入力バリデーション（純粋関数）。
class TrainingLogValidator {
  const TrainingLogValidator();

  static const double maxWeightKg = 999.99;

  ValidationResult validate({
    int? menuId,
    required double weightKg,
    required int reps,
    required DateTime trainedOn,
    required DateTime today,
  }) {
    if (menuId == null) {
      return const ValidationFailure('種目を選択してください');
    }

    if (weightKg <= 0 || weightKg > maxWeightKg) {
      return const ValidationFailure('重量が不正です');
    }

    final rounded = (weightKg * 100).round() / 100;
    if ((weightKg - rounded).abs() > 0.0001) {
      return const ValidationFailure('重量が不正です');
    }

    if (reps < 1) {
      return const ValidationFailure('回数が不正です');
    }

    final trainedDate = DateTime(trainedOn.year, trainedOn.month, trainedOn.day);
    final todayDate = DateTime(today.year, today.month, today.day);
    if (trainedDate.isAfter(todayDate)) {
      return const ValidationFailure('トレ日は今日以前を指定してください');
    }

    return const ValidationSuccess();
  }
}
