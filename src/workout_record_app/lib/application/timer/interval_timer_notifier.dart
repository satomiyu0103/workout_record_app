import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vibration/vibration.dart';

/// インターバルタイマーの状態（FR-SYS-002）。
class TimerState {
  const TimerState({
    this.remainingSeconds = 90,
    this.isRunning = false,
    this.isFinished = false,
    this.sessionDefaultSeconds = 90,
    this.endsAt,
  });

  final int remainingSeconds;
  final bool isRunning;
  final bool isFinished;
  final int sessionDefaultSeconds;
  final DateTime? endsAt;

  TimerState copyWith({
    int? remainingSeconds,
    bool? isRunning,
    bool? isFinished,
    int? sessionDefaultSeconds,
    DateTime? endsAt,
    bool clearEndsAt = false,
  }) {
    return TimerState(
      remainingSeconds: remainingSeconds ?? this.remainingSeconds,
      isRunning: isRunning ?? this.isRunning,
      isFinished: isFinished ?? this.isFinished,
      sessionDefaultSeconds:
          sessionDefaultSeconds ?? this.sessionDefaultSeconds,
      endsAt: clearEndsAt ? null : (endsAt ?? this.endsAt),
    );
  }
}

class IntervalTimerNotifier extends Notifier<TimerState>
    with WidgetsBindingObserver {
  Timer? _tickTimer;

  @override
  TimerState build() {
    WidgetsBinding.instance.addObserver(this);
    ref.onDispose(() {
      WidgetsBinding.instance.removeObserver(this);
      _tickTimer?.cancel();
    });
    return const TimerState();
  }

  void quickStart() {
    _startCountdown(state.sessionDefaultSeconds);
  }

  void adjustSeconds(int delta) {
    if (!state.isRunning) {
      final next = (state.remainingSeconds + delta).clamp(1, 600);
      state = state.copyWith(remainingSeconds: next);
      return;
    }

    final endsAt = state.endsAt;
    if (endsAt == null) {
      return;
    }
    final newEndsAt = endsAt.add(Duration(seconds: delta));
    final remaining = newEndsAt.difference(DateTime.now()).inSeconds;
    if (remaining <= 0) {
      _finish();
      return;
    }
    state = state.copyWith(endsAt: newEndsAt, remainingSeconds: remaining);
  }

  void resetDisplay() {
    _tickTimer?.cancel();
    state = TimerState(sessionDefaultSeconds: state.sessionDefaultSeconds);
  }

  void _startCountdown(int seconds) {
    _tickTimer?.cancel();
    final endsAt = DateTime.now().add(Duration(seconds: seconds));
    state = state.copyWith(
      remainingSeconds: seconds,
      isRunning: true,
      isFinished: false,
      endsAt: endsAt,
      sessionDefaultSeconds: seconds,
    );
    _tickTimer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
  }

  void _tick() {
    final endsAt = state.endsAt;
    if (endsAt == null) {
      return;
    }
    final remaining = endsAt.difference(DateTime.now()).inSeconds;
    if (remaining <= 0) {
      _finish();
      return;
    }
    state = state.copyWith(remainingSeconds: remaining);
  }

  Future<void> _finish() async {
    _tickTimer?.cancel();
    state = state.copyWith(
      remainingSeconds: 0,
      isRunning: false,
      isFinished: true,
      clearEndsAt: true,
    );
    if (await Vibration.hasVibrator() == true) {
      await Vibration.vibrate(duration: 500);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifecycleState) {
    if (lifecycleState == AppLifecycleState.resumed && this.state.isRunning) {
      final endsAt = this.state.endsAt;
      if (endsAt == null) {
        return;
      }
      final remaining = endsAt.difference(DateTime.now()).inSeconds;
      if (remaining <= 0) {
        _finish();
      } else {
        this.state = this.state.copyWith(remainingSeconds: remaining);
      }
    }
  }
}

final intervalTimerProvider =
    NotifierProvider<IntervalTimerNotifier, TimerState>(
  IntervalTimerNotifier.new,
);
