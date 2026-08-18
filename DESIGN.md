---
name: workout-record-app-design-system
description: 筋トレ記録アプリのデザイン正本。ダークモード既定・色・タイポ・コンポーネント。
colors:
  background-primary: "#121212"
  background-secondary: "#1E1E1E"
  accent-primary: "#3B82F6"
  text-primary: "#F5F5F5"
  text-secondary: "#A3A3A3"
  border-subtle: "#2E2E2E"
  success: "#10B981"
  warning: "#F59E0B"
  error: "#EF4444"
  info: "#64748B"
typography:
  display: "Roboto"
  body: "Roboto"
  mono: "Roboto Mono"
---

# Design System: workout_record_app

**Project ID:** なし

> 関連 FR: FR-SYS-003（ダークモード既定）· FR-SYS-004（テーマカラー切替・Could）

## 1. Visual Theme & Atmosphere

薄暗いトレーニングジム内でも視認しやすい **ダーク UI** を既定とする。インターバル中は片手・短時間の操作が多いため、情報密度は必要最小限に抑え、数値（重量・回数）を大きく読みやすく表示する。

**Key Characteristics:**

- ダーク背景に明るい文字とアクセント色で、セット間の視線移動を少なくする
- タップターゲットは最小 48×48dp（推奨 56dp）で、汗で滑りにくい大きめのボタン
- 入力画面は「種目・重量・回数・保存」が一画面で完結する階層
- 装飾より機能。グラフ・レポートは Phase 3 まで控えめ
- 利用シーン: オフラインジム、インターバル中の素早い記録

## 2. Color Palette & Roles

### Primary Foundation

- **Deep Gym Charcoal** (#121212) – 主背景。画面全体のベース
- **Elevated Card Slate** (#1E1E1E) – カード・入力パネル・ボトムシート

### Accent & Interactive

- **Electric Blue** (#3B82F6) – プライマリ CTA（保存・確定）、選択中タブ、アクティブな数値ステッパー

### Typography & Text Hierarchy

- **Off-White** (#F5F5F5) – 見出し・重量・回数の主要数値
- **Muted Gray** (#A3A3A3) – ラベル・補足・日付
- **Divider Gray** (#2E2E2E) – リスト区切り・入力枠

### Functional States

- **Success** (#10B981) – 保存完了
- **Warning** (#F59E0B) – タイマー残りわずか
- **Error** (#EF4444) – バリデーションエラー
- **Info** (#64748B) – ヒント・空状態

## 3. Typography Rules

**Primary Font Family:** Roboto（和文はシステムフォント `Noto Sans JP` でフォールバック）  
**Character:** 数値の読みやすさを優先。装飾は最小限

### Hierarchy & Weights

| 用途 | サイズ | ウェイト | 使用箇所 |
|---|---|---|---|
| Display (重量・回数) | 2rem | 600 | 入力画面の主要数値 |
| Section (H2) | 1.25rem | 600 | 画面タイトル |
| Body | 1rem | 400 | リスト本文 |
| Small / Meta | 0.875rem | 400 | 日付・種目ラベル |
| CTA Label | 1rem | 500 | 保存ボタン |

### Spacing Principles

- 数値ステッパー周り: 16dp
- リスト項目間: 8dp
- 画面左右パディング: 16dp

## 4. Component Stylings

### Buttons

- **Shape:** 12px 角丸
- **Primary CTA:** Electric Blue (#3B82F6) + Off-White テキスト。高さ 48dp 以上
- **Secondary:** アウトライン（Divider Gray）+ Off-White テキスト

### Cards & Containers

- **Background:** Elevated Card Slate (#1E1E1E)
- **Border:** 1px Divider Gray（必要時のみ）
- **Padding:** 16dp

### Navigation

- **Layout:** 底部 4 タブ（入力・カレンダー・レポート・**設定**）
- **Active:** Electric Blue アイコン + ラベル
- **Inactive:** Muted Gray

### Inputs & Forms

- **Background:** Deep Gym Charcoal または Elevated Card Slate
- **Border:** Divider Gray、フォーカス時 Accent
- **Error state:** Error 色の枠 + 下に Small テキスト

### Timer Overlay

- **背景:** 半透明の Deep Gym Charcoal
- **カウントダウン数字:** Display サイズ・Off-White
- **±30 秒ボタン:** Secondary スタイル

## 5. Layout Principles

### Grid & Structure

- **Mobile-first:** 縦画面を主とする
- **Max Content Width:** 端末幅（タブレットは 600px 中央寄せを検討）

### Touch Targets

- 最小 48×48dp（重量・回数の +/- ボタンは 56dp 推奨）

## 6. 将来テーマプリセット（FR-SYS-004・Could）

Phase 3 で三点リーダから配色プリセットを切り替える場合、以下を候補とする。

- **Default Dark**（本書の正本・MVP 既定）
- **OLED Black**（背景 #000000）
- **Warm Dark**（背景 #1A1614・アクセント #F97316）

MVP では Default Dark のみ実装する。

## 7. Notes for AI Generation

### Atmosphere (一行)

> Dark, gym-focused mobile UI with large tappable numbers for weight and reps, minimal chrome, electric blue accents.

### Color References

- Primary CTA: Electric Blue (#3B82F6)
- Background: Deep Gym Charcoal (#121212)
- Text: Off-White (#F5F5F5)

### Do / Don't

- **Do:** ダーク背景・大きな数値・明確な保存ボタン
- **Don't:** ライトモードを MVP の既定にしない。推奨目標値の UI を含めない

---

*Last updated: 2026-08-18*
