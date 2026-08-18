import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:workout_record_app/core/router/app_shell.dart';
import 'package:workout_record_app/core/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ja_JP');
  runApp(const ProviderScope(child: WorkoutRecordApp()));
}

class WorkoutRecordApp extends StatelessWidget {
  const WorkoutRecordApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '筋トレ記録',
      theme: buildAppTheme(),
      darkTheme: buildAppTheme(),
      themeMode: ThemeMode.dark,
      home: const AppShell(),
    );
  }
}
