import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:workout_record_app/presentation/screens/history_list_screen.dart';

/// 設定画面（FR-HIS-001 導線・プライバシーポリシー・アプリ情報）。
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        ListTile(
          leading: const Icon(Icons.history),
          title: const Text('トレーニング履歴'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute<void>(
                builder: (context) => const HistoryListScreen(),
              ),
            );
          },
        ),
        const Divider(),
        ListTile(
          leading: const Icon(Icons.privacy_tip_outlined),
          title: const Text('プライバシーポリシー'),
          onTap: () {
            showDialog<void>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('プライバシーポリシー'),
                content: const SingleChildScrollView(
                  child: Text(
                    '本アプリは完全オフラインで動作します。'
                    'トレーニング記録は端末内の SQLite データベースにのみ保存され、'
                    '外部サーバーへ送信されません。'
                    'ログインやアカウント登録は不要です。',
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('閉じる'),
                  ),
                ],
              ),
            );
          },
        ),
        ListTile(
          leading: const Icon(Icons.info_outline),
          title: const Text('アプリについて'),
          subtitle: FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Text('読み込み中...');
              }
              return Text('バージョン ${snapshot.data!.version}');
            },
          ),
        ),
      ],
    );
  }
}
