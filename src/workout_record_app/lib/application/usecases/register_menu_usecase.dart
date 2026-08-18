import 'package:workout_record_app/domain/entities/menu_item.dart';
import 'package:workout_record_app/domain/repositories/menu_repository.dart';
import 'package:workout_record_app/domain/validation/menu_validator.dart';

/// 種目カスタム登録ユースケース（FR-EXR-002）。
class RegisterMenuUseCase {
  RegisterMenuUseCase({
    required MenuRepository menuRepository,
    MenuValidator validator = const MenuValidator(),
  })  : _menuRepository = menuRepository,
        _validator = validator;

  final MenuRepository _menuRepository;
  final MenuValidator _validator;

  Future<({MenuItem? item, String? error})> execute(String rawName) async {
    final validation = _validator.validateName(rawName);
    if (validation is MenuValidationFailure) {
      return (item: null, error: validation.message);
    }

    final name = rawName.trim();
    if (await _menuRepository.existsByName(name)) {
      return (item: null, error: '同名の種目が既にあります');
    }

    final item = await _menuRepository.insert(name);
    return (item: item, error: null);
  }
}
