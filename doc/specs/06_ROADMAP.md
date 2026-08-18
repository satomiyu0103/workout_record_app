# ROADMAP

最終更新: 2026-08-18

フェーズ別の実装計画。短期の変更は [07_CHANGELOG.md](07_CHANGELOG.md) の `[Unreleased]` を参照。

機能コードの詳細は [04_機能一覧.md](04_機能一覧.md) を参照。

---

## 現在地

- 企画書を `doc/specs/` に展開済み（要件・設計・検証設計）
- `src/workout_record_app/` は未初期化（Flutter プロジェクト未作成）
- 次のマイルストーン: **Phase 1（MVP）** の Flutter 初期化と記録 CRUD

---

## Phase 1 — MVP（記録・履歴・タイマー・ダーク UI）

| # | 内容 | 関連 FR / NFR | ステータス |
|---|---|---|---|
| 1-1 | Flutter プロジェクト初期化（`src/workout_record_app/`） | — | 未着手 |
| 1-2 | SQLite スキーマ（menu_master, training_logs）・マイグレーション | FR-EXR, FR-REC | 未着手 |
| 1-3 | 種目プリセット・カスタム登録 | FR-EXR-001, FR-EXR-002 | 未着手 |
| 1-4 | トレ記録 CRUD（重量×回数） | FR-REC-001, FR-REC-002, FR-REC-003 | 未着手 |
| 1-5 | 履歴一覧・カレンダー（RM 非表示） | FR-HIS-001, FR-HIS-002 | 未着手 |
| 1-6 | インターバルタイマー（任意起動） | FR-SYS-002 | 未着手 |
| 1-7 | ダークモード既定テーマ | FR-SYS-003, DESIGN.md | 未着手 |
| 1-8 | NFR 検証（オフライン・起動時間） | NFR-SEC/OPS/PERF-001 | 未着手 |
| 1-9 | Android release APK ビルド・実機インストール・個人運用確認 | [08b_検証設計_Android配布運用.md](08b_検証設計_Android配布運用.md) | 未着手 |

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
| カレンダー種目別最大重量表示 | FR-HIS-002 将来構想。設定画面で表示種目を選ぶ案（MVP は記録マークのみ） |

---

## アーカイブ（テンプレ由来・他プロジェクト参照）

> 以下は **food-label-pdf-gas / SmartShelf PoC** の将来計画。本アプリの Phase とは無関係。

### Phase 4a〜4c（SmartShelf）

詳細: [sessions/2026-07-01_expiration-alert-plan.md](../ai/sessions/2026-07-01_expiration-alert-plan.md)
