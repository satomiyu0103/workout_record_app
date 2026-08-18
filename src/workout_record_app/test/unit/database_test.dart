import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
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

void main() {
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  late AppDatabase appDatabase;
  late MenuRepositoryImpl menuRepo;
  late TrainingLogRepositoryImpl logRepo;

  setUp(() async {
    appDatabase = AppDatabase(
      databaseFactory: databaseFactoryFfi,
      databasePath: 'test_${DateTime.now().microsecondsSinceEpoch}.db',
    );
    final db = await appDatabase.database;
    menuRepo = MenuRepositoryImpl(MenuDao(db));
    logRepo = TrainingLogRepositoryImpl(TrainingLogDao(db));
  });

  tearDown(() async {
    await appDatabase.close();
  });

  test('初回起動で8種目がシードされる', () async {
    final menus = await menuRepo.listAll();
    expect(menus.length, 8);
    expect(menus.first.name, 'ベンチプレス');
  });

  test('記録の保存と参照', () async {
    final menus = await menuRepo.listAll();
    final saveUseCase = SaveTrainingLogUseCase(repository: logRepo);
    final now = DateTime(2026, 8, 18, 12);

    final result = await saveUseCase.execute(
      menuId: menus.first.menuId,
      weightKg: 100,
      reps: 5,
      trainedOn: now,
      now: now,
    );

    expect(result.error, isNull);
    final logs = await logRepo.listByDateAndMenu(
      trainedOn: '2026-08-18',
      menuId: menus.first.menuId,
    );
    expect(logs.length, 1);
    expect(logs.first.weightKg, 100);
  });

  test('同名種目は登録拒否', () async {
    final registerUseCase = RegisterMenuUseCase(menuRepository: menuRepo);
    final result = await registerUseCase.execute('ベンチプレス');
    expect(result.error, contains('同名'));
  });

  test('存在しないIDの削除は冪等成功', () async {
    final deleteUseCase = DeleteTrainingLogUseCase(repository: logRepo);
    await expectLater(deleteUseCase.execute(99999), completes);
  });

  test('前回トレーニング日のセットを取得できる', () async {
    final menus = await menuRepo.listAll();
    final menuId = menus.first.menuId;
    final saveUseCase = SaveTrainingLogUseCase(repository: logRepo);

    await saveUseCase.execute(
      menuId: menuId,
      weightKg: 50,
      reps: 10,
      trainedOn: DateTime(2026, 8, 10),
      now: DateTime(2026, 8, 10, 9),
    );
    await saveUseCase.execute(
      menuId: menuId,
      weightKg: 55,
      reps: 8,
      trainedOn: DateTime(2026, 8, 15),
      now: DateTime(2026, 8, 15, 18, 30),
    );

    final previous = await logRepo.findPreviousSession(
      menuId: menuId,
      beforeTrainedOn: '2026-08-18',
    );

    expect(previous.trainedOn, '2026-08-15');
    expect(previous.logs.length, 1);
    expect(previous.logs.first.weightKg, 55);
  });

  test('体組成・健康記録を保存できる', () async {
    final profileRepo =
        DailyProfileRepositoryImpl(DailyProfileDao(await appDatabase.database));
    final useCase = SaveDailyProfileUseCase(repository: profileRepo);
    final now = DateTime(2026, 8, 18, 7, 30);

    final result = await useCase.execute(
      date: '2026-08-18',
      heightCm: 170.5,
      weightKg: 68.2,
      bloodPressureSystolic: 118,
      bloodPressureDiastolic: 76,
      now: now,
    );

    expect(result.error, isNull);
    final saved = await profileRepo.findByDate('2026-08-18');
    expect(saved?.heightCm, 170.5);
    expect(saved?.weightKg, 68.2);
    expect(saved?.bloodPressureSystolic, 118);
    expect(saved?.bloodPressureDiastolic, 76);
  });
}
