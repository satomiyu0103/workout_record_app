import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_record_app/application/timer/interval_timer_notifier.dart';
import 'package:workout_record_app/core/theme/app_colors.dart';

/// インターバルタイマーをオーバーレイ表示する（FR-SYS-002）。
///
/// `showDialog` / `AlertDialog` は実機で暗転のみになることがあるため、
/// 透明な [PageRoute] で中央パネルを載せる。
void showTimerOverlay(BuildContext context) {
  Navigator.of(context).push<void>(_TimerOverlayRoute());
}

class _TimerOverlayRoute extends PageRoute<void> {
  @override
  bool get barrierDismissible => true;

  @override
  Color? get barrierColor => Colors.black54;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 200);

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return _TimerOverlayPage(
      onClose: () => navigator?.pop(),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return FadeTransition(opacity: animation, child: child);
  }
}

class _TimerOverlayPage extends StatelessWidget {
  const _TimerOverlayPage({required this.onClose});

  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: onClose,
              behavior: HitTestBehavior.opaque,
            ),
          ),
          Center(
            child: GestureDetector(
              onTap: () {},
              child: Material(
                color: AppColors.backgroundSecondary,
                elevation: 8,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: const BorderSide(color: AppColors.borderSubtle),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    minWidth: 280,
                    maxWidth: 400,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'インターバルタイマー',
                          style: Theme.of(context).textTheme.titleLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 24),
                        _TimerOverlayContent(onClose: onClose),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TimerOverlayContent extends ConsumerWidget {
  const _TimerOverlayContent({required this.onClose});

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
