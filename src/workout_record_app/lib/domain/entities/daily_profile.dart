/// 日次の体組成・健康記録（FR-REC-004 拡張）。
class DailyProfile {
  const DailyProfile({
    required this.date,
    this.heightCm,
    this.weightKg,
    this.bloodPressureSystolic,
    this.bloodPressureDiastolic,
    required this.updatedAt,
  });

  final String date;
  final double? heightCm;
  final double? weightKg;
  final int? bloodPressureSystolic;
  final int? bloodPressureDiastolic;
  final String updatedAt;

  factory DailyProfile.fromMap(Map<String, Object?> map) {
    return DailyProfile(
      date: map['date']! as String,
      heightCm: (map['height_cm'] as num?)?.toDouble(),
      weightKg: (map['weight_kg'] as num?)?.toDouble(),
      bloodPressureSystolic: map['blood_pressure_systolic'] as int?,
      bloodPressureDiastolic: map['blood_pressure_diastolic'] as int?,
      updatedAt: map['updated_at']! as String,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'date': date,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'blood_pressure_systolic': bloodPressureSystolic,
      'blood_pressure_diastolic': bloodPressureDiastolic,
      'updated_at': updatedAt,
    };
  }

  bool get hasAnyValue =>
      heightCm != null ||
      weightKg != null ||
      bloodPressureSystolic != null ||
      bloodPressureDiastolic != null;
}
