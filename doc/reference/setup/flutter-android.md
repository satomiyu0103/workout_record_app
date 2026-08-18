# Flutter + Android 実機セットアップ（個人利用）

最終更新: 2026-08-18

> **検証表**: [08b_検証設計_Android配布運用.md](../../specs/08b_検証設計_Android配布運用.md)  
> **要件**: Android 8.0（API 26）以上 · 完全オフライン（[02_要件定義.md](../../specs/02_要件定義.md)）  
> **略語**: [検証・要件の略語.md](../cheatsheets/検証・要件の略語.md)（AC＝受け入れ基準、DT＝デシジョンテーブル、APK＝インストール用ファイル 等）

自分の Android スマホで筋トレ記録アプリを **開発中に試す** · **完成後に毎日使う** までの手順です。Google Play への公開は不要です。

---

## 全体の流れ（見返し用）

```text
【1 回だけ】PC に Flutter + Android SDK を入れる（[android-studio-windows.md](android-studio-windows.md)）
    ↓
【開発中】エミュレータ or USB 実機で flutter run（動作確認）
    ↓
【MVP 完成】flutter build apk --release（APK 作成）
    ↓
【日常利用】APK をスマホに入れてインストール
    ↓
【機能追加後】新しい APK で上書きインストール
```

| 段階 | 目的 | 主なコマンド / 操作 |
| --- | --- | --- |
| 環境構築 | PC で Android 向けにビルドできるようにする | `flutter doctor` · [android-studio-windows.md](android-studio-windows.md) |
| 開発中テスト（PC のみ） | エミュレータで画面を触って確認 | Device Manager 起動 → `flutter run` |
| 開発中テスト（実機） | コード変更をすぐ実機で確認 | USB → `flutter run` |
| 自動テスト | ロジック・Widget をコマンドで検証 | `flutter test` |
| 日常利用用ビルド | ジムで使う完成版を作る | `flutter build apk --release` |
| インストール | スマホにアプリを入れる | `adb install` または APK タップ |
| 更新 | バグ修正・機能追加を反映 | 新 APK で上書き |

---

## 1. PC の準備（初回のみ）

### 1-1. インストールするもの

| 項目 | 役割 |
| --- | --- |
| **Flutter SDK** | アプリのビルド・実行ツール |
| **Android Studio**（または Android SDK のみ） | Android 向けビルドに必要な SDK |
| **USB ケーブル** | 開発中に実機へ直接入れるときに使う |

公式: [Flutter インストール（Windows）](https://docs.flutter.dev/get-started/install/windows)

**Android SDK の入れ方・Android Studio の起動・日本語化** は [android-studio-windows.md](android-studio-windows.md) を参照（初回構築時の見返し用）。

### 1-2. 動作確認

PowerShell で次を実行します。

```powershell
flutter doctor
```

**Android toolchain** に ✗ が無い状態を目指します。指摘が出た場合は表示に従い修復します（ライセンス同意: `flutter doctor --android-licenses` など）。

---

## 2. Android スマホの準備（初回のみ）

### 2-1. 開発者向けオプションを ON

1. **設定** → **端末情報**（機種により「デバイス情報」）
2. **ビルド番号** を **7 回** タップ
3. 「開発者になりました」等の表示を確認

### 2-2. USB デバッグを ON

1. **設定** → **開発者向けオプション**
2. **USB デバッグ** を ON

### 2-3. OS バージョンの確認

本アプリは **Android 8.0（API 26）以上** を想定しています。それより古い端末は対象外です。

---

## 3. 開発中 — 動かす（`flutter run`）

`src/workout_record_app/` で開発中は、**エミュレータ（PC のみ）** または **USB 実機** で確認します。

### 3-A. PC 上で試す（エミュレータ）

スマホを繋がず PC だけで「テストプレイ」する方法です。

1. Android Studio → **Device Manager** で仮想端末を作成（API **26 以上**）し **▶** で起動  
   詳細: [android-studio-windows.md §5](android-studio-windows.md#5-pc-上でアプリを試すエミュレータ)
2. 接続確認・実行:

```powershell
cd src\workout_record_app
flutter devices
flutter run
```

| キー（ターミナル） | 意味 |
| --- | --- |
| `r` | ホットリロード |
| `R` | ホットリスタート |
| `q` | 終了 |

### 3-B. 実機 USB で動かす

### 3-1. 接続確認

```powershell
cd src\workout_record_app
flutter devices
```

スマホ名が一覧に出れば OK です。出ないときはケーブル・USB デバッグ・端末の「許可」ダイアログを確認します。

### 3-2. 実行

```powershell
flutter run
```

ビルド後、スマホにアプリが入り起動します。コードを直したあとはターミナルで `r`（ホットリロード）で UI を早く反映できます。

### 3-3. オフライン確認（NFR）

ジム利用を想定し、**機内モード ON** のまま次を試します。

- 記録の保存
- 履歴・カレンダーの表示
- タイマーの動作

詳細な期待結果は [08b_検証設計_Android配布運用.md](../../specs/08b_検証設計_Android配布運用.md) の DT-OPS-001 を参照してください。

### 3-C. 自動テスト（画面を触らない）

計算ロジックや Widget の表示をコマンドで一括検証します。

```powershell
cd src\workout_record_app
flutter test
```

---

## 4. 日常利用用 — release APK を作る

MVP の AC が満たせたら、開発用ではなく **自分用の完成版** をビルドします。

```powershell
cd src\workout_record_app
flutter build apk --release
```

成功すると、おおよそ次の場所に APK ができます。

```text
build\app\outputs\flutter-apk\app-release.apk
```

---

## 5. スマホへインストールする

Play ストアは使いません。**サイドロード**（自分で APK を入れる）です。

### 方法 A — USB + adb（PC から直接）

```powershell
adb install build\app\outputs\flutter-apk\app-release.apk
```

既に入っているアプリを上書きするとき:

```powershell
adb install -r build\app\outputs\flutter-apk\app-release.apk
```

### 方法 B — APK ファイルを渡す

1. `app-release.apk` を Google ドライブ・メール等でスマホへ送る
2. スマホでファイルを開き「インストール」
3. 初回は **提供元不明のアプリ** のインストールを許可する必要がある場合があります（自分で作った APK なので個人利用では一般的です）

---

## 6. アプリを更新するとき

1. コードを直したあと、再度 `flutter build apk --release`
2. 新しい `app-release.apk` を **上書きインストール**（方法 A の `-r` または方法 B で再インストール）

**注意**: 同じ署名（鍵）でビルドした APK だけが上書きできます。keystore を作り直すと、一度アンインストールが必要になることがあります（その場合 **記録データは消えます**）。

DB のスキーマを変えたリリースでは、更新後に記録が残るか実機で確認してください（[08b DT-OPS-002](../../specs/08b_検証設計_Android配布運用.md#dt-ops-002)）。

---

## 7. MVP 完了時のチェックリスト

実機で次を確認してから「日常利用」に切り替えると安全です。

- [ ] `app-release.apk` で起動できる（クラッシュしない）
- [ ] 初回起動で種目プリセットが選べる
- [ ] 機内モードで記録・履歴・タイマーが動く
- [ ] cold start から操作可能まで 1 秒以内（体感 + ストップウォッチ）
- [ ] 推奨重量・1RM が表示されない（MVP 否定 AC）

正本: [08_検証設計.md](../../specs/08_検証設計.md) · [08b_検証設計_Android配布運用.md](../../specs/08b_検証設計_Android配布運用.md)

---

## 8. よくあるつまずき

| 症状 | 確認すること |
| --- | --- |
| `flutter devices` に端末が出ない | USB デバッグ ON・ケーブル・端末の RSA 許可 |
| ビルドが失敗する | `flutter doctor` の Android 欄・SDK ライセンス |
| APK をタップしても入らない | 提供元不明アプリの許可・ストレージ権限 |
| 上書きインストールできない | 署名が変わっていないか。別 keystore ならアンインストールが必要 |
| 更新後に記録が消えた | アンインストールしてから入れ直していないか。マイグレーション失敗の可能性 |

---

## 関連ドキュメント

| 用途 | ファイル |
| --- | --- |
| Android Studio・SDK・起動・日本語化 | [android-studio-windows.md](android-studio-windows.md) |
| 配布・運用の DT / 状態遷移 | [08b_検証設計_Android配布運用.md](../../specs/08b_検証設計_Android配布運用.md) |
| 機能の受け入れ基準 | [08_検証設計.md](../../specs/08_検証設計.md) |
| 実装フェーズ | [06_ROADMAP.md](../../specs/06_ROADMAP.md) |
| UI デザイン | [DESIGN.md](../../../DESIGN.md) |
| 本手順の経緯（チャット知見） | [sessions/2026-08-18_android-studio-pc-dev-setup.md](../../ai/sessions/2026-08-18_android-studio-pc-dev-setup.md) |
