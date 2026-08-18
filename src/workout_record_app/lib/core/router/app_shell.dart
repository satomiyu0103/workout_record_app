import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_record_app/core/providers/app_providers.dart';
import 'package:workout_record_app/presentation/screens/calendar_screen.dart';
import 'package:workout_record_app/presentation/screens/input_screen.dart';
import 'package:workout_record_app/presentation/screens/report_screen.dart';
import 'package:workout_record_app/presentation/screens/settings_screen.dart';
import 'package:workout_record_app/presentation/widgets/timer_overlay.dart';

/// 4 タブのメインシェル（底部ナビゲーション）。
class AppShell extends ConsumerWidget {
  const AppShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(selectedTabIndexProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(_titleForTab(tabIndex)),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer_outlined),
            tooltip: 'インターバルタイマー',
            onPressed: () => showTimerOverlay(context),
          ),
        ],
      ),
      body: IndexedStack(
        index: tabIndex,
        children: const [
          InputScreen(),
          CalendarScreen(),
          ReportScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: tabIndex,
        onTap: (index) =>
            ref.read(selectedTabIndexProvider.notifier).state = index,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: '入力',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'カレンダー',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'レポート',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }

  String _titleForTab(int index) {
    return switch (index) {
      0 => 'トレーニング入力',
      1 => 'カレンダー',
      2 => 'レポート',
      3 => '設定',
      _ => '筋トレ記録',
    };
  }
}

String formatTrainedOn(DateTime date) {
  return DateFormat('yyyy-MM-dd').format(date);
}

DateTime parseTrainedOn(String value) {
  return DateTime.parse(value);
}
