# workout_record_app（Flutter）

筋トレ記録アプリの Flutter 実装本体。

## 実行

```powershell
cd src/workout_record_app
flutter pub get
flutter run          # 実機またはエミュレータ
flutter test
flutter build apk --release
```

Android 8.0（API 26）以上。手順: [doc/reference/setup/flutter-android.md](../../doc/reference/setup/flutter-android.md)

## 構成

| パス | 責務 |
|---|---|
| `lib/presentation/` | 画面・Widget |
| `lib/application/` | ユースケース・タイマー |
| `lib/domain/` | エンティティ・バリデーション |
| `lib/data/` | SQLite DAO |
| `lib/core/` | テーマ・Riverpod・ナビ |

設計: [doc/specs/03_システム設計.md](../../doc/specs/03_システム設計.md) · UI: [DESIGN.md](../../DESIGN.md)
