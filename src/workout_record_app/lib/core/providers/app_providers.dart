import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sqflite/sqflite.dart';
import 'package:workout_record_app/application/usecases/delete_training_log_usecase.dart';
import 'package:workout_record_app/application/usecases/register_menu_usecase.dart';
import 'package:workout_record_app/application/usecases/save_daily_profile_usecase.dart';
import 'package:workout_record_app/application/usecases/save_training_log_usecase.dart';
import 'package:workout_record_app/data/datasources/app_database.dart';
import 'package:workout_record_app/data/datasources/daily_profile_dao.dart';
import 'package:workout_record_app/data/datasources/menu_dao.dart';
import 'package:workout_record_app/data/datasources/training_log_dao.dart';
import 'package:workout_record_app/data/repositories/daily_profile_repository_impl.dart';
import 'package:workout_record_app/data/repositories/menu_repository_impl.dart';
import 'package:workout_record_app/data/repositories/training_log_repository_impl.dart';
import 'package:workout_record_app/domain/entities/daily_profile.dart';
import 'package:workout_record_app/domain/entities/menu_item.dart';
import 'package:workout_record_app/domain/entities/previous_session.dart';
import 'package:workout_record_app/domain/entities/training_log.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final databaseProvider = FutureProvider<Database>((ref) async {
  final appDb = ref.watch(appDatabaseProvider);
  return appDb.database;
});

final menuRepositoryProvider = FutureProvider<MenuRepositoryImpl>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return MenuRepositoryImpl(MenuDao(db));
});

final trainingLogRepositoryProvider =
    FutureProvider<TrainingLogRepositoryImpl>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return TrainingLogRepositoryImpl(TrainingLogDao(db));
});

final dailyProfileRepositoryProvider =
    FutureProvider<DailyProfileRepositoryImpl>((ref) async {
  final db = await ref.watch(databaseProvider.future);
  return DailyProfileRepositoryImpl(DailyProfileDao(db));
});

final registerMenuUseCaseProvider =
    FutureProvider<RegisterMenuUseCase>((ref) async {
  final repo = await ref.watch(menuRepositoryProvider.future);
  return RegisterMenuUseCase(menuRepository: repo);
});

final saveTrainingLogUseCaseProvider =
    FutureProvider<SaveTrainingLogUseCase>((ref) async {
  final repo = await ref.watch(trainingLogRepositoryProvider.future);
  return SaveTrainingLogUseCase(repository: repo);
});

final deleteTrainingLogUseCaseProvider =
    FutureProvider<DeleteTrainingLogUseCase>((ref) async {
  final repo = await ref.watch(trainingLogRepositoryProvider.future);
  return DeleteTrainingLogUseCase(repository: repo);
});

final saveDailyProfileUseCaseProvider =
    FutureProvider<SaveDailyProfileUseCase>((ref) async {
  final repo = await ref.watch(dailyProfileRepositoryProvider.future);
  return SaveDailyProfileUseCase(repository: repo);
});

final menuListProvider = FutureProvider<List<MenuItem>>((ref) async {
  final repo = await ref.watch(menuRepositoryProvider.future);
  return repo.listAll();
});

final selectedTabIndexProvider = StateProvider<int>((ref) => 0);

final timerOverlayVisibleProvider = StateProvider<bool>((ref) => false);

final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

final selectedMenuIdProvider = StateProvider<int?>((ref) => null);

typedef DayLogsKey = ({String trainedOn, int menuId});

final dayLogsProvider =
    FutureProvider.family<List<TrainingLog>, DayLogsKey>((ref, key) async {
  final repo = await ref.watch(trainingLogRepositoryProvider.future);
  return repo.listByDateAndMenu(trainedOn: key.trainedOn, menuId: key.menuId);
});

typedef PreviousSessionKey = ({String beforeTrainedOn, int menuId});

final previousSessionProvider =
    FutureProvider.family<PreviousSession, PreviousSessionKey>((ref, key) async {
  final repo = await ref.watch(trainingLogRepositoryProvider.future);
  return repo.findPreviousSession(
    menuId: key.menuId,
    beforeTrainedOn: key.beforeTrainedOn,
  );
});

final menuHistoryProvider =
    FutureProvider.family<List<TrainingLog>, int>((ref, menuId) async {
  final repo = await ref.watch(trainingLogRepositoryProvider.future);
  return repo.listByMenu(menuId);
});

typedef MonthKey = ({int year, int month});

final recordedDatesProvider =
    FutureProvider.family<Set<String>, MonthKey>((ref, key) async {
  final repo = await ref.watch(trainingLogRepositoryProvider.future);
  return repo.listRecordedDates(year: key.year, month: key.month);
});

final dailyProfileProvider =
    FutureProvider.family<DailyProfile?, String>((ref, date) async {
  final repo = await ref.watch(dailyProfileRepositoryProvider.future);
  return repo.findByDate(date);
});

void invalidateLogProviders(WidgetRef ref) {
  ref.invalidate(dayLogsProvider);
  ref.invalidate(menuHistoryProvider);
  ref.invalidate(recordedDatesProvider);
  ref.invalidate(previousSessionProvider);
}

void invalidateDailyProfileProviders(WidgetRef ref, String date) {
  ref.invalidate(dailyProfileProvider(date));
}
