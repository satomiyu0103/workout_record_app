# workout_record_app

筋トレの記録・進捗管理モバイルアプリ（オフライン完結）。

- **企画書**: Google Drive `20260523_企画書_筋トレ記録アプリ`
- **状態**: Phase 1 MVP 実装済み（`src/workout_record_app/`）。実機 APK は [flutter-android.md](doc/reference/setup/flutter-android.md) 参照
- **テンプレ**: ai-agent-devenv-template v2026.5

## 目的

インターバル中の最小タップで **重量・回数** を記録し、履歴一覧・カレンダーでトレーニングの振り返りを支援する。

- **MVP（Phase 1）**: 種目マスタ、記録 CRUD、履歴・カレンダー、インターバルタイマー、ダーク UI
- **Phase 2**: 1RM 自動計算（Epley 法）
- **MVP 外**: 推奨トレーニング強度の提示（目標重量・回数の自動提案）

## 次のステップ

1. Phase 1: Flutter + SQLite で `src/workout_record_app/` を初期化する
2. [06_ROADMAP.md](doc/specs/06_ROADMAP.md) の 1-1〜1-9 を実装する
3. 着手時は [AGENTS.md](AGENTS.md) と [08_検証設計.md](doc/specs/08_検証設計.md) の AC を参照する
4. 組み合わせテストは [08c_検証設計_組み合わせテスト.md](doc/specs/08c_検証設計_組み合わせテスト.md)
4. 実機へ入れる手順は [flutter-android.md](doc/reference/setup/flutter-android.md) · 検証表は [08b_検証設計_Android配布運用.md](doc/specs/08b_検証設計_Android配布運用.md)

## ドキュメント

| 種別 | パス |
|---|---|
| Agent ルーティング | [AGENTS.md](AGENTS.md) |
| 要件・設計 | [doc/specs/](doc/specs/) |
| Android 実機・個人利用 | [doc/reference/setup/flutter-android.md](doc/reference/setup/flutter-android.md) |
| UI デザイン | [DESIGN.md](DESIGN.md) |
| テンプレセットアップ | [TEMPLATE_SETUP.md](TEMPLATE_SETUP.md) |
