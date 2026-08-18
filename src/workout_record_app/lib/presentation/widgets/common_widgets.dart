import 'package:flutter/material.dart';
import 'package:workout_record_app/core/theme/app_colors.dart';

/// 確認ダイアログを表示する。
Future<bool> showConfirmDialog({
  required BuildContext context,
  required String title,
  required String message,
  String confirmLabel = '削除',
  String cancelLabel = 'キャンセル',
}) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return result ?? false;
}

/// 数値ステッパー（48dp 以上のタップターゲット）。
class NumberStepper extends StatelessWidget {
  const NumberStepper({
    super.key,
    required this.label,
    required this.value,
    required this.onDecrement,
    required this.onIncrement,
    this.displayValue,
  });

  final String label;
  final String value;
  final String? displayValue;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            _StepButton(icon: Icons.remove, onPressed: onDecrement),
            Expanded(
              child: Text(
                displayValue ?? value,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayMedium,
              ),
            ),
            _StepButton(icon: Icons.add, onPressed: onIncrement),
          ],
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 56,
      height: 56,
      child: OutlinedButton(
        onPressed: onPressed,
        child: Icon(icon),
      ),
    );
  }
}

/// セット行（ゴミ箱削除付き）。
class TrainingLogTile extends StatelessWidget {
  const TrainingLogTile({
    super.key,
    required this.weightKg,
    required this.reps,
    required this.onDelete,
    this.subtitle,
    this.readOnly = false,
  });

  final double weightKg;
  final int reps;
  final VoidCallback? onDelete;
  final String? subtitle;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final weightText = weightKg == weightKg.roundToDouble()
        ? '${weightKg.toInt()} kg'
        : '${weightKg.toStringAsFixed(2)} kg';

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        title: Text('$weightText × $reps 回'),
        subtitle: subtitle == null ? null : Text(subtitle!),
        trailing: readOnly || onDelete == null
            ? null
            : IconButton(
                icon: const Icon(Icons.delete_outline, color: AppColors.error),
                tooltip: '削除',
                onPressed: onDelete,
              ),
      ),
    );
  }
}
