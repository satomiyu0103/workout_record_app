import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:workout_record_app/core/providers/app_providers.dart';
import 'package:workout_record_app/core/router/app_shell.dart';
import 'package:workout_record_app/core/theme/app_colors.dart';

/// カレンダー画面（FR-HIS-002）。
class CalendarScreen extends ConsumerStatefulWidget {
  const CalendarScreen({super.key});

  @override
  ConsumerState<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends ConsumerState<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _lastTapDay;
  DateTime? _lastTapAt;

  void _handleDayTap(DateTime selectedDay, DateTime focusedDay) {
    if (!_isDaySelectable(selectedDay)) {
      return;
    }

    final now = DateTime.now();
    if (_lastTapDay != null &&
        _lastTapAt != null &&
        isSameDay(_lastTapDay, selectedDay) &&
        now.difference(_lastTapAt!) < const Duration(milliseconds: 400)) {
      ref.read(selectedDateProvider.notifier).state = DateTime(
        selectedDay.year,
        selectedDay.month,
        selectedDay.day,
      );
      ref.read(selectedTabIndexProvider.notifier).state = 0;
      _lastTapDay = null;
      _lastTapAt = null;
      return;
    }

    _lastTapDay = selectedDay;
    _lastTapAt = now;
    setState(() {
      _selectedDay = selectedDay;
      _focusedDay = focusedDay;
    });
  }

  bool _isDaySelectable(DateTime day) {
    final today = DateTime.now();
    final normalized = DateTime(day.year, day.month, day.day);
    final todayNormalized = DateTime(today.year, today.month, today.day);
    return !normalized.isAfter(todayNormalized);
  }

  DateTime get _calendarLastDay {
    final now = DateTime.now();
    return DateTime(now.year + 1, 12, 31);
  }

  @override
  Widget build(BuildContext context) {
    final monthKey = (year: _focusedDay.year, month: _focusedDay.month);
    final recordedAsync = ref.watch(recordedDatesProvider(monthKey));

    return recordedAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('読み込みエラー: $e')),
      data: (recordedDates) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: TableCalendar<void>(
            locale: 'ja_JP',
            firstDay: DateTime(2000),
            lastDay: _calendarLastDay,
            focusedDay: _focusedDay,
            enabledDayPredicate: _isDaySelectable,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            calendarFormat: CalendarFormat.month,
            startingDayOfWeek: StartingDayOfWeek.monday,
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: AppColors.info,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: AppColors.accentPrimary,
                shape: BoxShape.circle,
              ),
              markerDecoration: BoxDecoration(
                color: AppColors.success,
                shape: BoxShape.circle,
              ),
            ),
            eventLoader: (day) {
              final key = formatTrainedOn(day);
              return recordedDates.contains(key) ? [true] : [];
            },
            onPageChanged: (focusedDay) {
              setState(() => _focusedDay = focusedDay);
            },
            onDaySelected: _handleDayTap,
          ),
        );
      },
    );
  }
}
