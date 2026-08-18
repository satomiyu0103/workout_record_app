import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:workout_record_app/core/format/log_datetime_format.dart';
import 'package:workout_record_app/core/providers/app_providers.dart';
import 'package:workout_record_app/domain/entities/menu_item.dart';
import 'package:workout_record_app/domain/entities/training_log.dart';
import 'package:workout_record_app/presentation/widgets/common_widgets.dart';

/// 履歴一覧画面（FR-HIS-001）。
class HistoryListScreen extends ConsumerStatefulWidget {
  const HistoryListScreen({super.key});

  @override
  ConsumerState<HistoryListScreen> createState() => _HistoryListScreenState();
}

class _HistoryListScreenState extends ConsumerState<HistoryListScreen> {
  int? _selectedMenuId;

  @override
  Widget build(BuildContext context) {
    final menusAsync = ref.watch(menuListProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('トレーニング履歴')),
      body: menusAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('読み込みエラー: $e')),
        data: (menus) {
          final menuId = _selectedMenuId ??
              (menus.isNotEmpty ? menus.first.menuId : null);

          if (_selectedMenuId == null && menuId != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              setState(() => _selectedMenuId = menuId);
            });
          }

          final historyAsync = menuId == null
              ? const AsyncValue.data(<TrainingLog>[])
              : ref.watch(menuHistoryProvider(menuId));

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: _MenuDropdown(
                  menus: menus,
                  selectedMenuId: menuId,
                  onChanged: (id) => setState(() => _selectedMenuId = id),
                ),
              ),
              Expanded(
                child: historyAsync.when(
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('読み込みエラー: $e')),
                  data: (logs) {
                    if (logs.isEmpty) {
                      return const Center(child: Text('履歴がありません'));
                    }
                    return ListView.builder(
                      itemCount: logs.length,
                      itemBuilder: (context, index) {
                        final log = logs[index];
                        final dateTimeLabel = formatLogDateTime(log.createdAt);
                        return TrainingLogTile(
                          weightKg: log.weightKg,
                          reps: log.reps,
                          subtitle:
                              '$dateTimeLabel · ${log.menuName ?? ''}',
                          onDelete: () => _deleteLog(log.logId),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
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
}

class _MenuDropdown extends StatelessWidget {
  const _MenuDropdown({
    required this.menus,
    required this.selectedMenuId,
    required this.onChanged,
  });

  final List<MenuItem> menus;
  final int? selectedMenuId;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<int>(
      value: selectedMenuId,
      decoration: const InputDecoration(labelText: '種目'),
      items: [
        for (final menu in menus)
          DropdownMenuItem(value: menu.menuId, child: Text(menu.name)),
      ],
      onChanged: onChanged,
    );
  }
}
