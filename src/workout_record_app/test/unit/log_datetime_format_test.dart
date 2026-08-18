import 'package:flutter_test/flutter_test.dart';
import 'package:workout_record_app/core/format/log_datetime_format.dart';

void main() {
  test('記録時刻を日付と時刻付きで整形できる', () {
    expect(
      formatLogDateTime('2026-08-18T09:30:00.000Z'),
      '2026/08/18 18:30',
    );
  });

  test('記録時刻を時刻のみで整形できる', () {
    expect(
      formatLogTime('2026-08-18T09:30:00.000Z'),
      '18:30',
    );
  });
}
