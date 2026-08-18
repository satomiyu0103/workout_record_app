import 'package:intl/intl.dart';

/// 記録の ISO 8601 文字列をローカル時刻（HH:mm）に整形する。
String formatLogTime(String iso8601) {
  return DateFormat('HH:mm').format(DateTime.parse(iso8601).toLocal());
}

/// 記録の ISO 8601 文字列を日付＋時刻に整形する。
String formatLogDateTime(String iso8601) {
  return DateFormat('yyyy/MM/dd HH:mm')
      .format(DateTime.parse(iso8601).toLocal());
}

/// trained_on（yyyy-MM-dd）を表示用ラベルに整形する。
String formatTrainedOnLabel(String trainedOn) {
  return DateFormat('yyyy年M月d日').format(DateTime.parse(trainedOn));
}
