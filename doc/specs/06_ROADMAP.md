# ROADMAP

最終更新: 2026-08-18

フェーズ別の実装計画。短期の変更は [07_CHANGELOG.md](07_CHANGELOG.md) の `[Unreleased]` を参照。

機能コードの詳細は [04_機能一覧.md](04_機能一覧.md) を参照。

---

## 現在地

- 企画書を `doc/specs/` に展開済み（要件・設計・検証設計）
- `src/workout_record_app/` Flutter MVP 実装済み（`feat/FR-REC-004-post-mvp-ux` を `master` にマージ済み）
- **タイマー（FR-SYS-002）**: ロジックのみ実装済み。実機でオーバーレイ UI 未達 → 次回タブ化＋検証方法を検討
- 次のマイルストーン: **Phase 1 残**（タイマー UI・実機配布確認）→ **Phase 2** 1RM

---

## 次回開発（2026-08-19 以降・優先順）

利用者メモ + 実機 FB から整理。ブランチは **1 項目 1 ブランチ**（`git_branch_guard`）。

| 優先 | 内容 | 関連 FR | ブランチ案 | メモ |
|:---:|---|---|---|---|
| 1 | **タイマー検証方法の検討** | FR-SYS-002 | `docs/` または設計のみ | integration_test・実機 USB スモーク・`08` AC 追記（「パネル視認」）。オーバーレイは使わない方針で doc 確定してから実装 |
| 2 | **タイマーのタブ実装** | FR-SYS-002 | `feat/FR-SYS-002-timer-tab` | 底部ナビにタイマータブ（または専用画面）。オーバーレイコードは削除または非推奨化。実装前に `03_システム設計` を更新 |
| 3 | **± ボタン・単位（kg 等）のサイズ縮小** | FR-REC-001, FR-REC-004 | `feat/ux-value-stepper-compact` | `ValueStepper` のボタン・ラベルを小さくし、中央の数値を主役に |
| 4 | 前回記録の時刻を右寄せ | FR-REC-002 | `feat/ux-previous-log-time-align` | `TrainingLogTile` レイアウト。実機 FB More #2 |
| 5 | （任意）タイマー Widget / integration テスト | FR-SYS-002 | 上記 2 と同ブランチ可 | 実機接続時 `flutter test integration_test/ -d <device>` |
| 6 | release APK ビルド・実機インストール | 08b AC-DPL | `chore/` または手順のみ | Phase 1-9。SDK 環境で [flutter-android.md](../reference/setup/flutter-android.md) |

**着手順の目安**: 1（検討・AC）→ 2（タブ実装＋実機確認）→ 3・4（UX 微調整は独立 PR 可）。

---

## Phase 1 — MVP（記録・履歴・タイマー・ダーク UI）

| # | 内容 | 関連 FR / NFR | ステータス |
|---|---|---|---|
| 1-1 | Flutter プロジェクト初期化（`src/workout_record_app/`） | — | 実装済 |
| 1-2 | SQLite スキーマ（menu_master, training_logs）・マイグレーション | FR-EXR, FR-REC | 実装済 |
| 1-3 | 種目プリセット・カスタム登録 | FR-EXR-001, FR-EXR-002 | 実装済 |
| 1-4 | トレ記録 CRUD（重量×回数） | FR-REC-001, FR-REC-002, FR-REC-003 | 実装済 |
| 1-5 | 履歴一覧・カレンダー（RM 非表示） | FR-HIS-001, FR-HIS-002 | 実装済 |
| 1-6 | インターバルタイマー（任意起動） | FR-SYS-002 | **一部実装**（ロジック済・実機 UI 未達。次回タブ化） |
| 1-7 | ダークモード既定テーマ | FR-SYS-003, DESIGN.md | 実装済 |
| 1-8 | NFR 検証（オフライン・起動時間） | NFR-SEC/OPS/PERF-001 | 一部（単体テスト済・実機待ち） |
| 1-9 | Android release APK ビルド・実機インストール・個人運用確認 | [08b_検証設計_Android配布運用.md](08b_検証設計_Android配布運用.md) | 未着手（Android SDK 要・手順は doc 参照） |

**MVP 完了条件**: [08_検証設計.md](08_検証設計.md) の Must FR の AC がすべて満たされること。否定 AC（目標値・1RM 非表示）を含む。**実機での配布・運用**は [08b](08b_検証設計_Android配布運用.md) の AC-DPL / AC-OPS を満たすこと。手順は [flutter-android.md](../reference/setup/flutter-android.md)。

---

## Phase 2 — 1RM 算出

| # | 内容 | 関連 FR | ステータス |
|---|---|---|---|
| 2-1 | Epley 法純粋関数とユニットテスト | FR-CAL-001 | 未着手 |
| 2-2 | 履歴・カレンダーへの 1RM 表示 | FR-CAL-001, FR-HIS-002 | 未着手 |

---

## Phase 3 — Could 機能

| # | 内容 | 関連 FR | ステータス |
|---|---|---|---|
| 3-1 | 部位比率・1RM 推移グラフ | FR-VIS-001, FR-VIS-002 | 未着手 |
| 3-2 | ローカル CSV 出力 | FR-SYS-001 | 未着手 |
| 3-3 | 体重等日次記録 | FR-REC-004 | 未着手 |
| 3-4 | テーマカラー切替 | FR-SYS-004 | 未着手 |

---

## バックログ（未割当）

| 概要 | メモ |
|---|---|
| 目標値自動提示（漸進性過負荷） | FR-CAL-002・Wont。再検討時は GAP-A-002 を更新 |
| ユーザープロフィール CRUD | 企画書 F-01〜04。Could と統合検討 |
| 広告・収益化（任意） | 実装未定。[plans/ad-monetization-memo.md](plans/ad-monetization-memo.md)。累計 ¥3,000 目安・トレ中無広告 |
| タイマー既定秒数の設定変更 | FR-SYS-002 将来構想。MVP はセッション内保持のみ（利用者承認 2026-08-18） |
| タイマー UI（タブ化・検証） | 次回開発表を参照。オーバーレイは実機未達のため非採用 |
| カレンダー種目別最大重量表示 | FR-HIS-002 将来構想。設定画面で表示種目を選ぶ案（MVP は記録マークのみ） |

---

## アーカイブ（テンプレ由来・他プロジェクト参照）

> 以下は **food-label-pdf-gas / SmartShelf PoC** の将来計画。本アプリの Phase とは無関係。

### Phase 4a〜4c（SmartShelf）

詳細: [sessions/2026-07-01_expiration-alert-plan.md](../ai/sessions/2026-07-01_expiration-alert-plan.md)
