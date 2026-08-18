import 'package:flutter_test/flutter_test.dart';
import 'package:workout_record_app/application/timer/interval_timer_notifier.dart';

void main() {
  test('初期状態は90秒', () {
    const state = TimerState();
    expect(state.remainingSeconds, 90);
    expect(state.sessionDefaultSeconds, 90);
    expect(state.isRunning, isFalse);
  });

  test('copyWithで秒数を更新できる', () {
    const state = TimerState();
    final updated = state.copyWith(remainingSeconds: 60, isRunning: true);
    expect(updated.remainingSeconds, 60);
    expect(updated.isRunning, isTrue);
  });
}
