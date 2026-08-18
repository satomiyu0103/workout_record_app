import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:intl/intl.dart';

import 'package:workout_record_app/core/providers/app_providers.dart';

import 'package:workout_record_app/core/router/app_shell.dart';

import 'package:workout_record_app/domain/entities/daily_profile.dart';

import 'package:workout_record_app/presentation/widgets/number_picker_sheet.dart';

import 'package:workout_record_app/presentation/widgets/value_stepper.dart';



/// 身長・体重・血圧の日次記録画面（FR-REC-004 拡張）。

class HealthRecordScreen extends ConsumerStatefulWidget {

  const HealthRecordScreen({super.key, this.embedded = false});



  /// 底部タブ内では AppBar を持たない。

  final bool embedded;



  @override

  ConsumerState<HealthRecordScreen> createState() => _HealthRecordScreenState();

}



class _HealthRecordScreenState extends ConsumerState<HealthRecordScreen> {

  DateTime _selectedDate = todayDateOnly();

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



    final body = SingleChildScrollView(

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

          ValueStepper(

            label: '身長 (cm)',

            displayValue: _heightCm == null

                ? '未入力'

                : '${_heightCm!.toStringAsFixed(1)} cm',

            largeStepLabel: '5',

            showClear: true,

            onClear: () => setState(() => _heightCm = null),

            onSmallDecrement: () => setState(() {

              final current = _heightCm ?? 170;

              _heightCm = (current - 0.5).clamp(100, 250);

            }),

            onSmallIncrement: () => setState(() {

              final current = _heightCm ?? 170;

              _heightCm = (current + 0.5).clamp(100, 250);

            }),

            onLargeDecrement: () => setState(() {

              final current = _heightCm ?? 170;

              _heightCm = (current - 5).clamp(100, 250);

            }),

            onLargeIncrement: () => setState(() {

              final current = _heightCm ?? 170;

              _heightCm = (current + 5).clamp(100, 250);

            }),

            onTapValue: () => _pickHeight(context),

          ),

          const SizedBox(height: 16),

          ValueStepper(

            label: '体重 (kg)',

            displayValue: _weightKg == null

                ? '未入力'

                : '${_weightKg!.toStringAsFixed(1)} kg',

            largeStepLabel: '5',

            showClear: true,

            onClear: () => setState(() => _weightKg = null),

            onSmallDecrement: () => setState(() {

              final current = _weightKg ?? 60;

              _weightKg = (current - 0.1).clamp(20, 300);

            }),

            onSmallIncrement: () => setState(() {

              final current = _weightKg ?? 60;

              _weightKg = (current + 0.1).clamp(20, 300);

            }),

            onLargeDecrement: () => setState(() {

              final current = _weightKg ?? 60;

              _weightKg = (current - 5).clamp(20, 300);

            }),

            onLargeIncrement: () => setState(() {

              final current = _weightKg ?? 60;

              _weightKg = (current + 5).clamp(20, 300);

            }),

            onTapValue: () => _pickWeight(context),

          ),

          const SizedBox(height: 16),

          ValueStepper(

            label: '最高血圧 (mmHg)',

            displayValue: _bpSystolic == null ? '未入力' : '$_bpSystolic mmHg',

            largeStepLabel: '5',

            showClear: true,

            onClear: () => setState(() => _bpSystolic = null),

            onSmallDecrement: () => setState(() {

              final current = _bpSystolic ?? 120;

              _bpSystolic = (current - 1).clamp(50, 300);

            }),

            onSmallIncrement: () => setState(() {

              final current = _bpSystolic ?? 120;

              _bpSystolic = (current + 1).clamp(50, 300);

            }),

            onLargeDecrement: () => setState(() {

              final current = _bpSystolic ?? 120;

              _bpSystolic = (current - 5).clamp(50, 300);

            }),

            onLargeIncrement: () => setState(() {

              final current = _bpSystolic ?? 120;

              _bpSystolic = (current + 5).clamp(50, 300);

            }),

            onTapValue: () => _pickBpSystolic(context),

          ),

          const SizedBox(height: 16),

          ValueStepper(

            label: '最低血圧 (mmHg)',

            displayValue: _bpDiastolic == null ? '未入力' : '$_bpDiastolic mmHg',

            largeStepLabel: '5',

            showClear: true,

            onClear: () => setState(() => _bpDiastolic = null),

            onSmallDecrement: () => setState(() {

              final current = _bpDiastolic ?? 80;

              _bpDiastolic = (current - 1).clamp(30, 200);

            }),

            onSmallIncrement: () => setState(() {

              final current = _bpDiastolic ?? 80;

              _bpDiastolic = (current + 1).clamp(30, 200);

            }),

            onLargeDecrement: () => setState(() {

              final current = _bpDiastolic ?? 80;

              _bpDiastolic = (current - 5).clamp(30, 200);

            }),

            onLargeIncrement: () => setState(() {

              final current = _bpDiastolic ?? 80;

              _bpDiastolic = (current + 5).clamp(30, 200);

            }),

            onTapValue: () => _pickBpDiastolic(context),

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

    );



    if (widget.embedded) {

      return body;

    }



    return Scaffold(

      appBar: AppBar(title: const Text('体組成・健康記録')),

      body: body,

    );

  }



  Future<void> _pickHeight(BuildContext context) async {

    final picked = await showDecimalPickerSheet(

      context: context,

      title: '身長を選択',

      min: 100,

      max: 250,

      step: 0.5,

      initial: _heightCm ?? 170,

      unit: 'cm',

    );

    if (picked != null && mounted) {

      setState(() => _heightCm = picked);

    }

  }



  Future<void> _pickWeight(BuildContext context) async {

    final picked = await showDecimalPickerSheet(

      context: context,

      title: '体重を選択',

      min: 20,

      max: 300,

      step: 0.1,

      initial: _weightKg ?? 60,

      unit: 'kg',

    );

    if (picked != null && mounted) {

      setState(() => _weightKg = picked);

    }

  }



  Future<void> _pickBpSystolic(BuildContext context) async {

    final picked = await showIntPickerSheet(

      context: context,

      title: '最高血圧を選択',

      min: 50,

      max: 300,

      initial: _bpSystolic ?? 120,

      unit: 'mmHg',

    );

    if (picked != null && mounted) {

      setState(() => _bpSystolic = picked);

    }

  }



  Future<void> _pickBpDiastolic(BuildContext context) async {

    final picked = await showIntPickerSheet(

      context: context,

      title: '最低血圧を選択',

      min: 30,

      max: 200,

      initial: _bpDiastolic ?? 80,

      unit: 'mmHg',

    );

    if (picked != null && mounted) {

      setState(() => _bpDiastolic = picked);

    }

  }



  Future<void> _pickDate() async {

    final today = todayDateOnly();

    final initial = _selectedDate.isAfter(today) ? today : _selectedDate;

    final picked = await showDatePicker(

      context: context,

      initialDate: initial,

      firstDate: DateTime(2000),

      lastDate: today,

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

