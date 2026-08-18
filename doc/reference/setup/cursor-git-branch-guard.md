# Cursor Git ブランチガード（ローカル）

Cursor エージェントが **master 上でいきなり実装を始めない** ための仕組みです。ルール（文章）に加え、フック（Cursor が実行するスクリプト）で編集・コミットを物理的に止めます。

正本のルール: `.cursor/rules/git_branch_guard.mdc`（常時適用）

---

## 何が止まるか

| 操作 | master / main 上 | 作業ブランチ上 |
|:---|:---|:---|
| `src/` `doc/specs/` `tests/` `scripts/` `gas/` `config/` の編集 | **拒否** | 許可 |
| `git commit` | **拒否** | 許可 |
| ターン終了時の自動コミット（stop フック） | **実行しない** | 未コミット分をコミット（push なし） |

## 作業の流れ（モード B・既定）

```text
1. git switch master
2. git pull origin master
3. git switch -c feat/FR-XXX-短い説明
4. 実装・doc 更新
5. git commit（明示指示または stop フック）
6. git push -u origin HEAD
7. PR 作成（必要なとき）
```

ブランチ命名の詳細は `.cursor/rules/git_workflow.mdc` を参照。

---

## フックの場所

| ファイル | 役割 |
|:---|:---|
| `.cursor/hooks.json` | フック登録 |
| `.cursor/hooks/guard-master-edit.ps1` | master 上の保護パス編集を拒否（`preToolUse`） |
| `.cursor/hooks/guard-master-shell.ps1` | master 上の `git commit` を拒否（`beforeShellExecution`） |
| `.cursor/hooks/auto-commit-project.ps1` | 作業ブランチのみ自動コミット（`stop`） |

## 有効化の前提

1. **信頼済みワークスペース** — プロジェクトを Cursor で「信頼」する
2. **Customize → Hooks** — フックが登録されていることを確認（Hooks 出力チャンネルで実行ログも確認可）
3. 反映されないときは Cursor を再起動

公式: [Cursor Docs — Hooks](https://cursor.com/docs/hooks)

---

## 例外（ワンショット）

急ぎで master に 1 行だけ直すときなど、利用者が明示的に許可した場合:

```text
# プロジェクトルートで空ファイルを作成
New-Item -Path .cursor\.allow-master-edit -ItemType File -Force
```

作業後は **必ず削除** する。

---

## .gitignore について

`.cursor/` は公開リポジトリ向けに `.gitignore` で除外されています。フックとルールは **ローカルディスク上** で動作します。別 PC へ移すときは、この手順書と `.cursor/hooks*` `.cursor/rules/git_branch_guard.mdc` をコピーするか、テンプレ同期（`dev-template-sync`）で配布してください。

---

## トラブルシューティング

| 症状 | 確認 |
|:---|:---|
| フックが動かない | ワークスペースが信頼済みか / Customize → Hooks に表示があるか |
| 編集が止まりすぎる | 作業ブランチに切り替えたか / `.allow-master-edit` が残っていないか |
| master にコミットされた | フック導入前の変更の可能性。`git switch -c 救済ブランチ` で退避 |
