import 'package:workout_record_app/domain/entities/training_log.dart';

/// 前回トレーニング日のセット一覧。
class PreviousSession {
  const PreviousSession({
    required this.trainedOn,
    required this.logs,
  });

  final String trainedOn;
  final List<TrainingLog> logs;

  bool get isEmpty => logs.isEmpty;
}
