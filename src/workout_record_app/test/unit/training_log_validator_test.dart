import 'package:flutter_test/flutter_test.dart';
import 'package:workout_record_app/domain/validation/training_log_validator.dart';

void main() {
  const validator = TrainingLogValidator();
  final today = DateTime(2026, 8, 18);

  test('正常な入力は成功', () {
    final result = validator.validate(
      menuId: 1,
      weightKg: 80,
      reps: 5,
      trainedOn: today,
      today: today,
    );
    expect(result, isA<ValidationSuccess>());
  });

  test('種目未選択は最初のエラー', () {
    final result = validator.validate(
      menuId: null,
      weightKg: 0,
      reps: 0,
      trainedOn: today,
      today: today,
    );
    expect(result, isA<ValidationFailure>());
    expect((result as ValidationFailure).message, contains('種目'));
  });

  test('重量0以下は失敗', () {
    final result = validator.validate(
      menuId: 1,
      weightKg: 0,
      reps: 5,
      trainedOn: today,
      today: today,
    );
    expect(result, isA<ValidationFailure>());
    expect((result as ValidationFailure).message, contains('重量'));
  });

  test('小数第3位は失敗', () {
    final result = validator.validate(
      menuId: 1,
      weightKg: 80.123,
      reps: 5,
      trainedOn: today,
      today: today,
    );
    expect(result, isA<ValidationFailure>());
  });

  test('回数0は失敗', () {
    final result = validator.validate(
      menuId: 1,
      weightKg: 80,
      reps: 0,
      trainedOn: today,
      today: today,
    );
    expect(result, isA<ValidationFailure>());
    expect((result as ValidationFailure).message, contains('回数'));
  });

  test('未来日は失敗', () {
    final result = validator.validate(
      menuId: 1,
      weightKg: 80,
      reps: 5,
      trainedOn: today.add(const Duration(days: 1)),
      today: today,
    );
    expect(result, isA<ValidationFailure>());
    expect((result as ValidationFailure).message, contains('今日以前'));
  });
}
