# Android Studio（Windows）— SDK・起動・日本語化

最終更新: 2026-08-18

> **由来**: 開発環境構築チャット（PC 上でのテストプレイ・SDK 導入・日本語化の質疑）  
> **関連**: [flutter-android.md](flutter-android.md)（`flutter run`・APK 配布） · [08b_検証設計_Android配布運用.md](../../specs/08b_検証設計_Android配布運用.md)

Flutter で Android アプリをビルドするには **Android SDK**（ビルド用部品集）が必要です。Windows では **Android Studio を入れると SDK も一緒に入る** のがいちばん簡単です。

---

## 全体の位置づけ

```text
Android Studio をインストール
    ↓
SDK Manager で API 26 以上・Emulator を入れる
    ↓
（任意）日本語 UI に切り替え
    ↓
Device Manager でエミュレータ作成・起動
    ↓
flutter doctor → flutter run（[flutter-android.md](flutter-android.md)）
```

| ツール | 役割 |
| --- | --- |
| **Android Studio** | SDK の管理・エミュレータ起動・（任意）IDE |
| **Android SDK** | `adb`・ビルドツール・プラットフォーム API |
| **Flutter SDK** | アプリのビルド・実行（別途インストール） |

本アプリのコード編集は **Cursor** でも問題ありません。Android Studio は主に SDK とエミュレータ用です。

---

## 1. Android Studio のインストール（SDK 同梱）

### 1-1. ダウンロード

1. [Android Studio 公式](https://developer.android.com/studio) からインストーラー（`.exe`）を取得
2. 実行し、ウィザードは基本 **Next** で進める
3. 次が含まれることを確認（既定で入ることが多い）
   - Android Studio
   - **Android SDK**
   - **Android Virtual Device**（PC 上の仮想スマホ＝エミュレータ）

### 1-2. 初回セットアップ（SDK の中身）

1. 起動後の **Setup Wizard** で **Standard** を選ぶ
2. SDK の保存場所を確認（多くの場合）

   ```text
   C:\Users\<ユーザー名>\AppData\Local\Android\Sdk
   ```

3. **Finish** でダウンロード完了まで待つ（数 GB・時間がかかる）

### 1-3. 追加パッケージ（SDK Manager）

1. ウェルカム画面の **More Actions** → **SDK Manager**  
   （プロジェクトを開いている場合: **File** → **Settings** → **Languages & Frameworks** → **Android SDK**）
2. **SDK Platforms**: **Android 8.0（Oreo）** 以上（**API Level 26** 以上）にチェック
3. **SDK Tools**: 次を確認
   - Android SDK Build-Tools
   - Android SDK Platform-Tools
   - Android SDK Command-line Tools
   - **Android Emulator**（PC だけで試す場合は必須）
4. **Apply** → ダウンロード

---

## 2. 起動方法（Windows）

### 方法 A — スタートメニュー（推奨）

1. **Windows キー** を押す
2. **Android Studio** と入力して起動

### 方法 B — 実行ファイルを直接

多くの環境では次のパスです（インストール先は環境により異なります）。

```text
C:\Program Files\Android\Android Studio\bin\studio64.exe
```

スタートメニューのショートカットを右クリック → **ファイルの場所を開く** で実際のパスを確認できます。

### 初回起動時

| 画面 | 初回の選び方 |
| --- | --- |
| Import Settings | **Do not import settings** |
| Setup Wizard | **Standard** |

初回は SDK ダウンロードで **数分** かかることがあります。

---

## 3. 環境変数（任意だが推奨）

`adb` 等を PowerShell から使うときに設定します。設定後は **PowerShell を開き直す**。

| 変数 | 値（例） |
| --- | --- |
| `ANDROID_HOME` | `C:\Users\<ユーザー名>\AppData\Local\Android\Sdk` |

**Path** に追加:

```text
%ANDROID_HOME%\platform-tools
%ANDROID_HOME%\cmdline-tools\latest\bin
```

設定場所: **設定** → **システム** → **バージョン情報** → **システムの詳細設定** → **環境変数**

確認:

```powershell
adb version
flutter doctor
flutter doctor --android-licenses   # ライセンスに y で同意
```

---

## 4. 日本語 UI にする（Meerkat 2024.3 以降）

**日本語にできます** が、プラグイン画面から「Japanese Language Pack」を検索して入れる方法は **使えません**（Meerkat 以降、Android Studio 向けの配布が停止）。

### 手順の概要

1. Android Studio のバージョンを確認（**Help** → **About**）
2. **同じビルド番号**の [IntelliJ IDEA Community Edition（ZIP）](https://www.jetbrains.com/ja-jp/idea/download/other/) をダウンロード
3. ZIP を解凍し、`plugins\localization-ja` フォルダをコピー
4. Android Studio の `plugins` フォルダに貼り付け  
   例: `C:\Program Files\Android\Android Studio\plugins\localization-ja`
5. Android Studio を起動 → `Ctrl+Alt+S` → **Appearance & Behavior** → **System Settings** → **Language and Region** → **Japanese 日本語** → 再起動

右下に **Enable Japanese and Restart** が出たらそれを押しても同じです。

### 注意

- **バージョンは必ず揃える**（Android Studio と IntelliJ のビルド番号不一致は動作不良の原因）
- 古い Japanese Language Pack プラグインが入っていたら先にアンインストール
- メニューは日本語でも、エラーメッセージ・公式ドキュメントは英語が多い
- **日本語化は必須ではない**（SDK 管理とエミュレータ起動は英語 UI のままで十分）

---

## 5. PC 上でアプリを試す（エミュレータ）

スマホを繋がず PC だけで動作確認する方法です。詳細な `flutter run` 手順は [flutter-android.md §3-A](flutter-android.md#3-a-pc-上で試すエミュレータ) を参照。

### エミュレータの作成・起動

1. Android Studio → **More Actions** → **Virtual Device Manager**（Device Manager）
2. **Create Device** → 端末（例: Pixel 7）→ システムイメージ **API 26 以上** をダウンロード・選択
3. 作成した仮想端末の **▶** で起動

### Flutter から実行

```powershell
cd src\workout_record_app
flutter devices          # エミュレータ名が出るか確認
flutter run            # ビルドして起動
```

開発中のショートカット（ターミナル上）:

| キー | 意味 |
| --- | --- |
| `r` | ホットリロード（UI の変更を素早く反映） |
| `R` | ホットリスタート |
| `q` | 終了 |

---

## 6. よくあるつまずき

| 症状 | 確認すること |
| --- | --- |
| `flutter` が見つからない | Flutter SDK を別途インストールし Path を通す（[Flutter Windows 公式](https://docs.flutter.dev/get-started/install/windows)） |
| `adb` が見つからない | `ANDROID_HOME` と Path。PowerShell を開き直す |
| `flutter doctor` の Android に ✗ | SDK Manager で不足パッケージ・ライセンス（`flutter doctor --android-licenses`） |
| `flutter devices` に端末が出ない | エミュレータ起動済みか、USB デバッグ ON か |
| 日本語化後に起動しない | IntelliJ と Android Studio のバージョン不一致。`localization-ja` を削除して再配置 |
| エミュレータが重い | RAM 割当を下げる、または実機 USB で `flutter run` |

---

## 関連ドキュメント

| 用途 | ファイル |
| --- | --- |
| `flutter run`・APK・実機 USB | [flutter-android.md](flutter-android.md) |
| 配布・運用の検証表 | [08b_検証設計_Android配布運用.md](../../specs/08b_検証設計_Android配布運用.md) |
| セッション記録（本 doc の経緯） | [sessions/2026-08-18_android-studio-pc-dev-setup.md](../../ai/sessions/2026-08-18_android-studio-pc-dev-setup.md) |
