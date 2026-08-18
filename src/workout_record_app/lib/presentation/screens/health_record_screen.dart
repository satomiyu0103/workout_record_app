import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_record_app/core/providers/app_providers.dart';
import 'package:workout_record_app/core/router/app_shell.dart';
import 'package:workout_record_app/domain/entities/daily_profile.dart';

/// 身長・体重・血圧の日次記録画面（FR-REC-004 拡張）。
class HealthRecordScreen extends ConsumerStatefulWidget {
  const HealthRecordScreen({super.key});

  @override
  ConsumerState<HealthRecordScreen> createState() => _HealthRecordScreenState();
}

class _HealthRecordScreenState extends ConsumerState<HealthRecordScreen> {
  DateTime _selectedDate = DateTime.now();
  double? _heightCm;
  double? _weightKg;
  int? _bpSystolic;
  int? _bpDiastolic;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadProfileForSelectedDate();
    });
  }

  void _applyProfile(DailyProfile? profile) {
    setState(() {
      _heightCm = profile?.heightCm;
      _weightKg = profile?.weightKg;
      _bpSystolic = profile?.bloodPressureSystolic;
      _bpDiastolic = profile?.bloodPressureDiastolic;
    });
  }

  Future<void> _loadProfileForSelectedDate() async {
    final dateKey = formatTrainedOn(_selectedDate);
    final profile = await ref.read(dailyProfileProvider(dateKey).future);
    if (mounted) {
      _applyProfile(profile);
    }
  }

  @override
  Widget build(BuildContext context) {
    final dateKey = formatTrainedOn(_selectedDate);
    final profileAsync = ref.watch(dailyProfileProvider(dateKey));

    return Scaffold(
      appBar: AppBar(title: const Text('体組成・健康記録')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            OutlinedButton(
              onPressed: _pickDate,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('記録日'),
                  Text(DateFormat('yyyy年M月d日').format(_selectedDate)),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _OptionalNumberStepper(
              label: '身長 (cm)',
              display: _heightCm == null
                  ? '未入力'
                  : '${_heightCm!.toStringAsFixed(1)} cm',
              onDecrement: () => setState(() {
                final current = _heightCm ?? 170;
                _heightCm = (current - 0.5).clamp(100, 250);
              }),
              onIncrement: () => setState(() {
                final current = _heightCm ?? 170;
                _heightCm = (current + 0.5).clamp(100, 250);
              }),
              onClear: () => setState(() => _heightCm = null),
            ),
            const SizedBox(height: 16),
            _OptionalNumberStepper(
              label: '体重 (kg)',
              display: _weightKg == null
                  ? '未入力'
                  : '${_weightKg!.toStringAsFixed(1)} kg',
              onDecrement: () => setState(() {
                final current = _weightKg ?? 60;
                _weightKg = (current - 0.1).clamp(20, 300);
              }),
              onIncrement: () => setState(() {
                final current = _weightKg ?? 60;
                _weightKg = (current + 0.1).clamp(20, 300);
              }),
              onClear: () => setState(() => _weightKg = null),
            ),
            const SizedBox(height: 16),
            _OptionalNumberStepper(
              label: '収縮期血圧 (mmHg)',
              display: _bpSystolic == null ? '未入力' : '$_bpSystolic mmHg',
              onDecrement: () => setState(() {
                final current = _bpSystolic ?? 120;
                _bpSystolic = (current - 1).clamp(50, 300);
              }),
              onIncrement: () => setState(() {
                final current = _bpSystolic ?? 120;
                _bpSystolic = (current + 1).clamp(50, 300);
              }),
              onClear: () => setState(() => _bpSystolic = null),
            ),
            const SizedBox(height: 16),
            _OptionalNumberStepper(
              label: '拡張期血圧 (mmHg)',
              display: _bpDiastolic == null ? '未入力' : '$_bpDiastolic mmHg',
              onDecrement: () => setState(() {
                final current = _bpDiastolic ?? 80;
                _bpDiastolic = (current - 1).clamp(30, 200);
              }),
              onIncrement: () => setState(() {
                final current = _bpDiastolic ?? 80;
                _bpDiastolic = (current + 1).clamp(30, 200);
              }),
              onClear: () => setState(() => _bpDiastolic = null),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: profileAsync.isLoading ? null : _save,
              child: const Text('保存'),
            ),
            const SizedBox(height: 16),
            profileAsync.when(
              loading: () => const SizedBox.shrink(),
              error: (e, _) => Text('読み込みエラー: $e'),
              data: (profile) => _SavedSummary(profile: profile),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _selectedDate = DateTime(picked.year, picked.month, picked.day);
    });
    await _loadProfileForSelectedDate();
  }

  Future<void> _save() async {
    final dateKey = formatTrainedOn(_selectedDate);
    final useCase = await ref.read(saveDailyProfileUseCaseProvider.future);
    final result = await useCase.execute(
      date: dateKey,
      heightCm: _heightCm,
      weightKg: _weightKg,
      bloodPressureSystolic: _bpSystolic,
      bloodPressureDiastolic: _bpDiastolic,
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

    invalidateDailyProfileProviders(ref, dateKey);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('保存しました')),
    );
  }
}

class _OptionalNumberStepper extends StatelessWidget {
  const _OptionalNumberStepper({
    required this.label,
    required this.display,
    required this.onDecrement,
    required this.onIncrement,
    required this.onClear,
  });

  final String label;
  final String display;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodyMedium),
            TextButton(onPressed: onClear, child: const Text('クリア')),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            SizedBox(
              width: 56,
              height: 56,
              child: OutlinedButton(
                onPressed: onDecrement,
                child: const Icon(Icons.remove),
              ),
            ),
            Expanded(
              child: Text(
                display,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              width: 56,
              height: 56,
              child: OutlinedButton(
                onPressed: onIncrement,
                child: const Icon(Icons.add),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SavedSummary extends StatelessWidget {
  const _SavedSummary({required this.profile});

  final DailyProfile? profile;

  @override
  Widget build(BuildContext context) {
    if (profile == null || !profile!.hasAnyValue) {
      return Text(
        'この日の保存済み記録はありません',
        style: Theme.of(context).textTheme.bodyMedium,
      );
    }

    final parts = <String>[];
    if (profile!.heightCm != null) {
      parts.add('身長 ${profile!.heightCm!.toStringAsFixed(1)} cm');
    }
    if (profile!.weightKg != null) {
      parts.add('体重 ${profile!.weightKg!.toStringAsFixed(1)} kg');
    }
    if (profile!.bloodPressureSystolic != null &&
        profile!.bloodPressureDiastolic != null) {
      parts.add(
        '血圧 ${profile!.bloodPressureSystolic}/${profile!.bloodPressureDiastolic} mmHg',
      );
    }

    return Text(
      '保存済み: ${parts.join(' · ')}',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
