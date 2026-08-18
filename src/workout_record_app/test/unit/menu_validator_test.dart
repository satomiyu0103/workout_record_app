import 'package:flutter_test/flutter_test.dart';
import 'package:workout_record_app/domain/validation/menu_validator.dart';

void main() {
  const validator = MenuValidator();

  test('空文字は登録不可', () {
    final result = validator.validateName('');
    expect(result, isA<MenuValidationFailure>());
    expect((result as MenuValidationFailure).message, contains('種目名'));
  });

  test('空白のみは登録不可', () {
    final result = validator.validateName('   ');
    expect(result, isA<MenuValidationFailure>());
  });

  test('有効な種目名は成功', () {
    final result = validator.validateName('  カスタム種目  ');
    expect(result, isA<MenuValidationSuccess>());
  });
}
