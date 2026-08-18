import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_record_app/application/timer/interval_timer_notifier.dart';
import 'package:workout_record_app/core/theme/app_colors.dart';

/// インターバルタイマーをダイアログで表示する（FR-SYS-002）。
///
/// ボトムシートだとレイアウト未確定時の hitTest で落ちることがあるため Dialog を使う。
void showTimerOverlay(BuildContext context) {
  showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (dialogContext) {
      return Dialog(
        backgroundColor: AppColors.backgroundSecondary,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: 280),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: TimerOverlay(
              onClose: () => Navigator.of(dialogContext).pop(),
            ),
          ),
        ),
      );
    },
  );
}

class TimerOverlay extends ConsumerWidget {
  const TimerOverlay({super.key, required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final timer = ref.watch(intervalTimerProvider);
    final notifier = ref.read(intervalTimerProvider.notifier);
    final color = timer.remainingSeconds <= 10 && timer.isRunning
        ? AppColors.warning
        : AppColors.textPrimary;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'インターバルタイマー',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        Text(
          timer.isFinished ? '完了' : '${timer.remainingSeconds}',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 64,
                color: color,
              ),
        ),
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            OutlinedButton(
              onPressed: () => notifier.adjustSeconds(-30),
              child: const Text('-30秒'),
            ),
            const SizedBox(width: 16),
            OutlinedButton(
              onPressed: () => notifier.adjustSeconds(30),
              child: const Text('+30秒'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: timer.isRunning
                ? null
                : () {
                    if (timer.isFinished) {
                      notifier.resetDisplay();
                    }
                    notifier.quickStart();
                  },
            child: Text(timer.isRunning ? 'カウント中...' : 'クイックスタート'),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            notifier.resetDisplay();
            onClose();
          },
          child: const Text('閉じる'),
        ),
      ],
    );
  }
}
