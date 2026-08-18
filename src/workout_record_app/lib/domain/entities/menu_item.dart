/// 種目マスタのエンティティ。
class MenuItem {
  const MenuItem({
    required this.menuId,
    required this.name,
    this.category,
    this.bodyPart,
    this.calcType,
  });

  final int menuId;
  final String name;
  final String? category;
  final String? bodyPart;
  final String? calcType;

  factory MenuItem.fromMap(Map<String, Object?> map) {
    return MenuItem(
      menuId: map['menu_id']! as int,
      name: map['name']! as String,
      category: map['category'] as String?,
      bodyPart: map['body_part'] as String?,
      calcType: map['calc_type'] as String?,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'menu_id': menuId,
      'name': name,
      'category': category,
      'body_part': bodyPart,
      'calc_type': calcType,
    };
  }
}
