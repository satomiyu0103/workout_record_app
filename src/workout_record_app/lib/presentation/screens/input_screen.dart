import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_record_app/core/format/log_datetime_format.dart';
import 'package:workout_record_app/core/providers/app_providers.dart';
import 'package:workout_record_app/core/router/app_shell.dart';
import 'package:workout_record_app/domain/entities/menu_item.dart';
import 'package:workout_record_app/presentation/widgets/common_widgets.dart';
import 'package:workout_record_app/presentation/widgets/number_picker_sheet.dart';
import 'package:workout_record_app/presentation/widgets/value_stepper.dart';

/// トレーニング入力画面（FR-REC-001〜003）。
class InputScreen extends ConsumerStatefulWidget {
  const InputScreen({super.key});

  @override
  ConsumerState<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends ConsumerState<InputScreen> {
  double _weightKg = 60;
  int _reps = 8;

  @override
  Widget build(BuildContext context) {
    final selectedDate = ref.watch(selectedDateProvider);
    final selectedMenuId = ref.watch(selectedMenuIdProvider);
    final menusAsync = ref.watch(menuListProvider);

    final trainedOn = formatTrainedOn(selectedDate);
    final dayKey = selectedMenuId == null
        ? null
        : (trainedOn: trainedOn, menuId: selectedMenuId);
    final logsAsync = dayKey == null ? null : ref.watch(dayLogsProvider(dayKey));

    final previousKey = selectedMenuId == null
        ? null
        : (beforeTrainedOn: trainedOn, menuId: selectedMenuId);
    final previousAsync = previousKey == null
        ? null
        : ref.watch(previousSessionProvider(previousKey));

    return menusAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('読み込みエラー: $e')),
      data: (menus) {
        final effectiveMenuId = selectedMenuId ??
            (menus.isNotEmpty ? menus.first.menuId : null);
        if (selectedMenuId == null && effectiveMenuId != null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ref.read(selectedMenuIdProvider.notifier).state = effectiveMenuId;
          });
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DatePickerRow(selectedDate: selectedDate),
              const SizedBox(height: 16),
              _MenuSelector(
                menus: menus,
                selectedMenuId: effectiveMenuId,
                onChanged: (id) =>
                    ref.read(selectedMenuIdProvider.notifier).state = id,
                onAddMenu: () => _showAddMenuDialog(context),
              ),
              const SizedBox(height: 24),
              ValueStepper(
                label: '重量 (kg)',
                displayValue: _formatWeight(_weightKg),
                largeStepLabel: '10',
                onSmallDecrement: () => setState(() {
                  _weightKg = (_weightKg - 2.5).clamp(0, 999.99);
                }),
                onSmallIncrement: () => setState(() {
                  _weightKg = (_weightKg + 2.5).clamp(0, 999.99);
                }),
                onLargeDecrement: () => setState(() {
                  _weightKg = (_weightKg - 10).clamp(0, 999.99);
                }),
                onLargeIncrement: () => setState(() {
                  _weightKg = (_weightKg + 10).clamp(0, 999.99);
                }),
                onTapValue: () => _pickWeight(context),
              ),
              const SizedBox(height: 16),
              ValueStepper(
                label: '回数',
                displayValue: '$_reps 回',
                largeStepLabel: '5',
                onSmallDecrement: () =>
                    setState(() => _reps = (_reps - 1).clamp(1, 999)),
                onSmallIncrement: () =>
                    setState(() => _reps = (_reps + 1).clamp(1, 999)),
                onLargeDecrement: () =>
                    setState(() => _reps = (_reps - 5).clamp(1, 999)),
                onLargeIncrement: () =>
                    setState(() => _reps = (_reps + 5).clamp(1, 999)),
                onTapValue: () => _pickReps(context),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: effectiveMenuId == null
                    ? null
                    : () => _save(
                          menuId: effectiveMenuId,
                          trainedOn: selectedDate,
                        ),
                child: const Text('保存'),
              ),
              const SizedBox(height: 24),
              Text(
                '当日のセット',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (logsAsync == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('種目を選択してください'),
                )
              else
                logsAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('一覧の読み込みエラー: $e'),
                  data: (logs) {
                    if (logs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('まだセットがありません'),
                      );
                    }
                    return Column(
                      children: [
                        for (final log in logs)
                          TrainingLogTile(
                            weightKg: log.weightKg,
                            reps: log.reps,
                            subtitle: formatLogTime(log.createdAt),
                            onDelete: () => _deleteLog(log.logId),
                          ),
                      ],
                    );
                  },
                ),
              const SizedBox(height: 24),
              Text(
                '前回の記録',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              if (previousAsync == null)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Text('種目を選択してください'),
                )
              else
                previousAsync.when(
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('前回記録の読み込みエラー: $e'),
                  data: (session) {
                    if (session.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: Text('前回の記録はありません'),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatTrainedOnLabel(session.trainedOn),
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 4),
                        for (final log in session.logs)
                          TrainingLogTile(
                            weightKg: log.weightKg,
                            reps: log.reps,
                            subtitle: formatLogTime(log.createdAt),
                            readOnly: true,
                            onDelete: null,
                          ),
                      ],
                    );
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  String _formatWeight(double value) {
    if (value == value.roundToDouble()) {
      return '${value.toInt()} kg';
    }
    return '${value.toStringAsFixed(2)} kg';
  }

  Future<void> _pickWeight(BuildContext context) async {
    final picked = await showDecimalPickerSheet(
      context: context,
      title: '重量を選択',
      min: 0,
      max: 300,
      step: 2.5,
      initial: _weightKg,
      unit: 'kg',
      fractionDigits: 2,
    );
    if (picked != null && picked > 0 && mounted) {
      setState(() => _weightKg = picked);
    }
  }

  Future<void> _pickReps(BuildContext context) async {
    final picked = await showIntPickerSheet(
      context: context,
      title: '回数を選択',
      min: 1,
      max: 999,
      initial: _reps,
      unit: '回',
    );
    if (picked != null && mounted) {
      setState(() => _reps = picked);
    }
  }

  Future<void> _save({
    required int menuId,
    required DateTime trainedOn,
  }) async {
    final useCase = await ref.read(saveTrainingLogUseCaseProvider.future);
    final result = await useCase.execute(
      menuId: menuId,
      weightKg: _weightKg,
      reps: _reps,
      trainedOn: trainedOn,
      now: DateTime.now(),
    );

    if (!mounted) {
      return;
    }

    if (result.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result.error!)),
      );
      return;
    }

    invalidateLogProviders(ref);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('保存しました')),
    );
  }

  Future<void> _deleteLog(int logId) async {
    final confirmed = await showConfirmDialog(
      context: context,
      title: 'セットを削除',
      message: 'このセットを削除しますか？',
    );
    if (!confirmed) {
      return;
    }

    final useCase = await ref.read(deleteTrainingLogUseCaseProvider.future);
    await useCase.execute(logId);
    invalidateLogProviders(ref);
  }

  Future<void> _showAddMenuDialog(BuildContext context) async {
    final controller = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('種目を追加'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: '種目名'),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('登録'),
          ),
        ],
      ),
    );

    if (result == null || !mounted) {
      return;
    }

    final useCase = await ref.read(registerMenuUseCaseProvider.future);
    final registerResult = await useCase.execute(result);

    if (!mounted) {
      return;
    }

    if (registerResult.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(registerResult.error!)),
      );
      return;
    }

    ref.invalidate(menuListProvider);
    ref.read(selectedMenuIdProvider.notifier).state =
        registerResult.item!.menuId;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('種目を登録しました')),
    );
  }
}

class _DatePickerRow extends ConsumerWidget {
  const _DatePickerRow({required this.selectedDate});

  final DateTime selectedDate;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final label = DateFormat('yyyy年M月d日').format(selectedDate);

    return OutlinedButton(
      onPressed: () async {
        final today = todayDateOnly();
        final initial =
            selectedDate.isAfter(today) ? today : selectedDate;
        final picked = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: DateTime(2000),
          lastDate: today,
        );
        if (picked != null) {
          ref.read(selectedDateProvider.notifier).state = DateTime(
            picked.year,
            picked.month,
            picked.day,
          );
        }
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('トレ日'),
          Text(label),
        ],
      ),
    );
  }
}

class _MenuSelector extends StatelessWidget {
  const _MenuSelector({
    required this.menus,
    required this.selectedMenuId,
    required this.onChanged,
    required this.onAddMenu,
  });

  final List<MenuItem> menus;
  final int? selectedMenuId;
  final ValueChanged<int?> onChanged;
  final VoidCallback onAddMenu;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        DropdownButtonFormField<int>(
          value: selectedMenuId,
          decoration: const InputDecoration(labelText: '種目'),
          items: [
            for (final menu in menus)
              DropdownMenuItem(
                value: menu.menuId,
                child: Text(menu.name),
              ),
          ],
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
        OutlinedButton.icon(
          onPressed: onAddMenu,
          icon: const Icon(Icons.add),
          label: const Text('種目を追加'),
        ),
      ],
    );
  }
}
