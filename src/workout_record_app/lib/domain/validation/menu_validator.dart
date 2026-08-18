/// 種目名バリデーションの結果。
sealed class MenuValidationResult {
  const MenuValidationResult();
}

class MenuValidationSuccess extends MenuValidationResult {
  const MenuValidationSuccess();
}

class MenuValidationFailure extends MenuValidationResult {
  const MenuValidationFailure(this.message);

  final String message;
}

/// 種目登録の入力バリデーション（純粋関数）。
class MenuValidator {
  const MenuValidator();

  MenuValidationResult validateName(String rawName) {
    final name = rawName.trim();
    if (name.isEmpty) {
      return const MenuValidationFailure('種目名を入力してください');
    }
    return const MenuValidationSuccess();
  }
}
