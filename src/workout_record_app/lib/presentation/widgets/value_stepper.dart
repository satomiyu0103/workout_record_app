import 'package:flutter/material.dart';
import 'package:workout_record_app/core/theme/app_colors.dart';

/// 小刻み・大刻みの ± とタップでリール選択できる数値ステッパー。
class ValueStepper extends StatelessWidget {
  const ValueStepper({
    super.key,
    required this.label,
    required this.displayValue,
    required this.onSmallDecrement,
    required this.onSmallIncrement,
    this.onLargeDecrement,
    this.onLargeIncrement,
    this.largeStepLabel,
    this.onTapValue,
    this.onClear,
    this.showClear = false,
  });

  final String label;
  final String displayValue;
  final VoidCallback onSmallDecrement;
  final VoidCallback onSmallIncrement;
  final VoidCallback? onLargeDecrement;
  final VoidCallback? onLargeIncrement;
  final String? largeStepLabel;
  final VoidCallback? onTapValue;
  final VoidCallback? onClear;
  final bool showClear;

  @override
  Widget build(BuildContext context) {
    final hasLargeStep =
        onLargeDecrement != null && onLargeIncrement != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            if (showClear && onClear != null)
              TextButton(onPressed: onClear, child: const Text('クリア')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            if (hasLargeStep) ...[
              _StepButton(
                icon: Icons.remove,
                label: largeStepLabel,
                size: 64,
                onPressed: onLargeDecrement!,
              ),
              const SizedBox(width: 8),
            ],
            _StepButton(
              icon: Icons.remove,
              size: 72,
              onPressed: onSmallDecrement,
            ),
            Expanded(
              child: InkWell(
                onTap: onTapValue,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Column(
                    children: [
                      Text(
                        displayValue,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                      if (onTapValue != null)
                        Text(
                          'タップで選択',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
            _StepButton(
              icon: Icons.add,
              size: 72,
              onPressed: onSmallIncrement,
            ),
            if (hasLargeStep) ...[
              const SizedBox(width: 8),
              _StepButton(
                icon: Icons.add,
                label: largeStepLabel,
                size: 64,
                onPressed: onLargeIncrement!,
              ),
            ],
          ],
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({
    required this.icon,
    required this.onPressed,
    required this.size,
    this.label,
  });

  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: EdgeInsets.zero,
        ),
        child: label == null
            ? Icon(icon, size: size >= 72 ? 32 : 24)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 20),
                  Text(label!, style: Theme.of(context).textTheme.labelSmall),
                ],
              ),
      ),
    );
  }
}
