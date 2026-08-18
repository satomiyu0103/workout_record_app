/// トレーニング記録のエンティティ。
class TrainingLog {
  const TrainingLog({
    required this.logId,
    required this.menuId,
    required this.trainedOn,
    required this.weightKg,
    required this.reps,
    required this.createdAt,
    this.menuName,
  });

  final int logId;
  final int menuId;
  final String trainedOn;
  final double weightKg;
  final int reps;
  final String createdAt;
  final String? menuName;

  factory TrainingLog.fromMap(Map<String, Object?> map) {
    return TrainingLog(
      logId: map['log_id']! as int,
      menuId: map['menu_id']! as int,
      trainedOn: map['trained_on']! as String,
      weightKg: (map['weight_kg']! as num).toDouble(),
      reps: map['reps']! as int,
      createdAt: map['created_at']! as String,
      menuName: map['menu_name'] as String?,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'log_id': logId,
      'menu_id': menuId,
      'trained_on': trainedOn,
      'weight_kg': weightKg,
      'reps': reps,
      'created_at': createdAt,
    };
  }
}
