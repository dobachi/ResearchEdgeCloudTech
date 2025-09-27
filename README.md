# 調査報告書テンプレート

AI支援による調査報告書作成のためのGitHubテンプレートリポジトリです。

## 特徴

- 🤖 AI指示書システムによる調査・報告書作成支援
- 📊 構造化された報告書テンプレート（エグゼクティブサマリ、参考文献を含む）
- 🔍 信頼性の高い情報源の活用と適切な引用管理
- 📝 HTML/PDF形式での報告書出力対応
- 🎯 IT技術、法制度、ソフトウェアプロジェクト等の調査に最適化

## クイックスタート

### 🚀 ワンライナーで新しいプロジェクトを作成（推奨）

以下のワンライナーを実行すると、GitHubプライベートリポジトリ付きの新しいプロジェクトが自動作成されます：

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/dobachi/ResearchTemplate/main/scripts/create-project.sh) your-project-name
```

**前提条件:**
- [GitHub CLI (gh)](https://cli.github.com/) がインストール済み
- GitHub CLI が認証済み (`gh auth login`)

**このワンライナーが実行する処理:**
1. ✅ 新しいプロジェクトディレクトリを作成
2. ✅ このテンプレートを複製
3. ✅ GitHubにプライベートリポジトリを作成
4. ✅ 新しいリポジトリにプッシュ
5. ✅ AI指示書システム（サブモジュール）を初期化
6. ✅ プロジェクト設定を自動更新

### 手動での作成方法

#### 1. テンプレートからリポジトリを作成

GitHubで「Use this template」ボタンをクリックして、新しいリポジトリを作成します。

#### 2. 初期設定

```bash
# リポジトリをクローン
git clone https://github.com/dobachi/ResearchEdgeCloudTech.git
cd ResearchEdgeCloudTech

# AI指示書システムの初期化
git submodule update --init --recursive

# プロジェクト設定の確認
cat instructions/PROJECT.md
```

### 調査開始

プロジェクト作成後、以下のように調査を開始できます：

```bash
# プロジェクトディレクトリに移動
cd your-project-name

# 調査テーマの設定（次のセクション参照）
# その後、AI支援による調査開始（さらに次のセクション参照）
```

### 3. 調査テーマの設定

`reports/config.yaml`で調査テーマと範囲を設定：

```yaml
title: "調査報告書タイトル"
topic: "調査テーマ"
scope:
  - IT技術
  - 法制度
  - その他
```

### 4. AI支援による調査開始

```bash
# チェックポイント管理で進捗を追跡
scripts/checkpoint.sh start "調査タスク名" 5

# AI指示書を使用して調査を開始
# Claude/Cursor/Gemini等のAIツールで以下を実行：
# 1. instructions/PROJECT.mdを読み込み
# 2. AI指示書システムのROOT_INSTRUCTIONに従って作業
```

## ディレクトリ構造

```
.
├── README.md                    # このファイル
├── instructions/                # AI指示書と設定
│   ├── PROJECT.md              # プロジェクト固有の設定
│   └── ai_instruction_kits/    # AI指示書システム（サブモジュール）
├── reports/                     # 報告書の保管場所
│   ├── templates/              # 報告書テンプレート
│   │   ├── report_template.md  # Markdownテンプレート
│   │   └── styles/            # HTMLスタイルシート
│   ├── samples/               # サンプル報告書
│   └── config.yaml           # 報告書設定
├── sources/                    # 調査資料の保管場所
│   ├── references/            # 参考文献
│   ├── data/                  # データファイル
│   └── notes/                 # 調査メモ
├── scripts/                    # ユーティリティスクリプト
│   ├── checkpoint.sh          # 進捗管理
│   ├── commit.sh             # クリーンなコミット
│   ├── build-report.sh       # 報告書ビルド
│   └── worktree-manager.sh   # Git worktree管理
└── output/                    # 生成された報告書（gitignore対象）
    ├── html/
    └── pdf/
```

## 報告書作成のベストプラクティス

### 1. 信頼性の高い情報源の活用

- 🏛️ 行政機関の公式発表
- 📚 査読付き学術論文
- 📋 国際標準・業界標準
- 🏢 企業の公式技術文書

### 2. 適切な引用と参照

- すべての事実に引用元を明記
- 参考文献リストとの相互参照を確保
- 引用形式の一貫性を保つ

### 3. 多角的な視点

- 複数の見解や理論を検討
- バランスの取れた分析
- 明確な考察と事実の区別

### 4. 報告書の構成

必須項目：
- エグゼクティブサマリ
- 目次
- 本文（背景、調査方法、結果、考察）
- 結論
- 参考文献一覧

## 報告書のビルドとエクスポート

### HTMLレポートの生成

```bash
scripts/build-report.sh html reports/your-report.md
```

### PDFレポートの生成

```bash
scripts/build-report.sh pdf reports/your-report.md
```

## AI指示書の活用

このプロジェクトには調査・報告書作成に特化したAI指示書が含まれています：

- `research_analyst.md` - 調査分析の専門指示書
- `report_writer.md` - 報告書執筆の専門指示書
- `fact_checker.md` - ファクトチェックと引用管理

詳細は`instructions/PROJECT.md`を参照してください。

## コントリビューション

プルリクエストを歓迎します。大きな変更の場合は、まずissueを開いて変更内容について議論してください。

## ライセンス

[Apache-2.0](LICENSE)

## サポート

問題が発生した場合は、[Issues](https://github.com/dobachi/ResearchEdgeCloudTech/issues)でお知らせください。