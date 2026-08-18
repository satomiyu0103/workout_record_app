# 0004. Flutter 状態管理に Riverpod を採用

- 日付: 2026-08-18
- 状態: 採用

## 文脈

MVP（Phase 1）で画面（入力・カレンダー・履歴・タイマー）と SQLite の状態を同期する必要がある。`03_システム設計.md` では Riverpod / Provider が未確定（GAP-B-001）だった。

## 決定

**flutter_riverpod** を状態管理の正本とする。MVP は最小構成（`Provider` / `Notifier` 中心）で始め、画面が増えたら整理する。

## 結果

| 項目 | 内容 |
|---|---|
| メリット | コンパイル時の安全性、テスト容易、Flutter コミュニティで新規採用が多い |
| デメリット | 初回学習コスト（Provider よりやや多い） |
| 影響範囲 | `pubspec.yaml`、`lib/` の presentation / application 層、Widget テストのモック |
| 非採用 | Provider（小規模向きだが本プロジェクトは層分離＋複数画面のため Riverpod を優先） |

利用者承認: 2026-08-18。
