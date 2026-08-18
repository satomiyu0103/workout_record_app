import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:workout_record_app/core/providers/app_providers.dart';
import 'package:workout_record_app/core/router/app_shell.dart';
import 'package:workout_record_app/presentation/screens/calendar_screen.dart';
import 'package:workout_record_app/presentation/screens/health_record_screen.dart';
import 'package:workout_record_app/presentation/screens/input_screen.dart';
import 'package:workout_record_app/presentation/screens/report_screen.dart';
import 'package:workout_record_app/presentation/screens/settings_screen.dart';
import 'package:workout_record_app/presentation/widgets/timer_overlay.dart';

/// 5 タブのメインシェル（底部ナビゲーション）。
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
          HealthRecordScreen(embedded: true),
          CalendarScreen(),
          ReportScreen(),
          SettingsScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabIndex,
        onDestinationSelected: (index) =>
            ref.read(selectedTabIndexProvider.notifier).state = index,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center),
            label: '入力',
          ),
          NavigationDestination(
            icon: Icon(Icons.monitor_weight_outlined),
            selectedIcon: Icon(Icons.monitor_weight),
            label: '体組成',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: 'カレンダー',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'レポート',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: '設定',
          ),
        ],
      ),
    );
  }

  String _titleForTab(int index) {
    return switch (index) {
      0 => 'トレーニング入力',
      1 => '体組成記録',
      2 => 'カレンダー',
      3 => 'レポート',
      4 => '設定',
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
