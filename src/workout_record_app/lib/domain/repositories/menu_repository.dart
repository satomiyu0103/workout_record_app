import 'package:workout_record_app/domain/entities/menu_item.dart';

/// 種目マスタのリポジトリ抽象。
abstract class MenuRepository {
  Future<List<MenuItem>> listAll();

  Future<bool> existsByName(String name);

  Future<MenuItem> insert(String name);
}
