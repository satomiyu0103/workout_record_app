import 'package:flutter/material.dart';
import 'package:workout_record_app/core/theme/app_colors.dart';

/// リール（くるくる回すホイール）で数値を選ぶボトムシート。
Future<double?> showDecimalPickerSheet({
  required BuildContext context,
  required String title,
  required double min,
  required double max,
  required double step,
  required double initial,
  required String unit,
  int fractionDigits = 1,
}) async {
  final values = <double>[];
  for (var v = min; v <= max + step / 2; v += step) {
    values.add(double.parse(v.toStringAsFixed(fractionDigits)));
  }
  final initialIndex = values.indexWhere(
    (v) => (v - initial).abs() < step / 2,
  );

  return showModalBottomSheet<double>(
    context: context,
    backgroundColor: AppColors.backgroundSecondary,
    builder: (sheetContext) {
      var selectedIndex = initialIndex >= 0 ? initialIndex : 0;
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(sheetContext).textTheme.titleLarge),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListWheelScrollView.useDelegate(
                  itemExtent: 48,
                  perspective: 0.005,
                  diameterRatio: 1.5,
                  controller: FixedExtentScrollController(
                    initialItem: selectedIndex,
                  ),
                  onSelectedItemChanged: (index) => selectedIndex = index,
                  childDelegate: ListWheelChildBuilderDelegate(
                    childCount: values.length,
                    builder: (context, index) {
                      final v = values[index];
                      final text = fractionDigits == 0
                          ? '${v.toInt()} $unit'
                          : '${v.toStringAsFixed(fractionDigits)} $unit';
                      return Center(
                        child: Text(
                          text,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      );
                    },
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      child: const Text('キャンセル'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () =>
                          Navigator.pop(sheetContext, values[selectedIndex]),
                      child: const Text('決定'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

/// 整数用リールピッカー。
Future<int?> showIntPickerSheet({
  required BuildContext context,
  required String title,
  required int min,
  required int max,
  required int initial,
  required String unit,
}) async {
  final result = await showDecimalPickerSheet(
    context: context,
    title: title,
    min: min.toDouble(),
    max: max.toDouble(),
    step: 1,
    initial: initial.toDouble(),
    unit: unit,
    fractionDigits: 0,
  );
  return result?.round();
}
