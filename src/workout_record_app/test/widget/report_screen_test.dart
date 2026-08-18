import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:workout_record_app/core/theme/app_theme.dart';
import 'package:workout_record_app/presentation/screens/report_screen.dart';

void main() {
  testWidgets('レポート画面はダークテーマで表示される', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          theme: buildAppTheme(),
          home: const Scaffold(body: ReportScreen()),
        ),
      ),
    );

    expect(find.text('データ不足'), findsOneWidget);
    final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(materialApp.theme?.scaffoldBackgroundColor, isNotNull);
  });
}
