import 'package:workout_record_app/domain/entities/daily_profile.dart';

/// 日次体組成・健康記録のリポジトリ抽象。
abstract class DailyProfileRepository {
  Future<DailyProfile?> findByDate(String date);

  Future<DailyProfile> upsert(DailyProfile profile);
}
