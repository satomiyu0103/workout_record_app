import 'package:flutter/material.dart';
import 'package:workout_record_app/core/theme/app_colors.dart';

/// レポート画面（Phase 3 までプレースホルダ）。
class ReportScreen extends StatelessWidget {
  const ReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.bar_chart, size: 64, color: AppColors.info),
            SizedBox(height: 16),
            Text(
              'データ不足',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            SizedBox(height: 8),
            Text(
              'グラフ機能は今後のバージョンで追加予定です',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
