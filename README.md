# クラウドエッジ技術研究プロジェクト

AI支援によるクラウドエッジ技術の包括的調査・分析プロジェクトです。IoT、5G/6G、エッジAI、産業IoTなどの最新技術動向を体系的に研究し、日本の産業界における戦略的機会を分析します。

## 特徴

- 🌐 クラウドエッジ技術の体系的分類と市場分析
- 🤖 AI指示書システムによる高度な技術調査支援
- 📊 日本産業界の競争優位性分析と戦略提言
- 🔍 信頼性の高い技術情報源（IEEE、3GPP、ETSI等）の活用
- 📝 HTML/PDF形式での専門技術報告書出力
- 🎯 製造業DX、スマートシティ、自動運転分野への特化

## 研究成果

### 📄 現在の調査報告書

1. **クラウドエッジ技術に関する調査報告書** (v1.0)
   - 技術分類フレームワークの確立
   - 市場動向と成長予測分析（2030年457億ドル市場）
   - 日本企業の競争優位性評価
   - 戦略的提言とロードマップ

### 🔍 調査対象技術領域

- **デバイス連携型**: IoTゲートウェイ、プロトコル統合
- **産業機械統合型**: OT/IT統合、デジタルツイン
- **通信インフラ型**: 5G/MEC、ネットワーク仮想化
- **プラットフォーム型**: コンテナ技術、エッジAI

## プロジェクト開始方法

### 1. 環境準備

```bash
# リポジトリをクローン
git clone https://github.com/dobachi/ResearchEdgeCloudTech.git
cd ResearchEdgeCloudTech

# AI指示書システムの初期化
git submodule update --init --recursive

# プロジェクト設定の確認
cat instructions/PROJECT.md
```

### 2. 調査開始の手順

```bash
# 現在の報告書を確認
ls reports/

# HTMLレポート生成
scripts/build-report.sh html reports/cloud_edge_technology_research.md

# PDF生成（Pandoc必要）
scripts/build-report.sh pdf reports/cloud_edge_technology_research.md
```

### 3. AI支援による分析拡張

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

### 1. 技術情報源の活用

- 🌐 国際標準化機関（IEEE、3GPP、ETSI、ITU-T）
- 📊 市場調査機関（IDC、Gartner、McKinsey）
- 🏭 主要技術企業（AWS、Microsoft、Google、日本企業）
- 📚 査読付き学術論文（arXiv、IEEE Xplore）

### 2. 技術分類フレームワーク

この調査では以下の4つの主要カテゴリで技術を分類：
- **デバイス連携型**: IoT-クラウド統合技術
- **産業機械統合型**: 製造業向けOT/IT統合
- **通信インフラ型**: 5G/6G + エッジコンピューティング
- **プラットフォーム型**: クラウドネイティブエッジサービス

### 3. 市場分析の視点

- グローバル市場規模と成長予測
- 地域別市場分布と特徴
- 日本企業の技術的優位性分析
- 競合動向と差別化戦略

## 報告書のビルドとエクスポート

### Quartoベースレポートの生成（推奨）

```bash
# HTML版の生成
scripts/build-quarto-report.sh html

# PDF版の生成
scripts/build-quarto-report.sh pdf

# 全形式の生成
scripts/build-quarto-report.sh all
```

### 従来形式レポートの生成

```bash
# HTMLレポートの生成
scripts/build-report.sh html reports/cloud_edge_technology_research.md

# PDFレポートの生成
scripts/build-report.sh pdf reports/cloud_edge_technology_research.md

# 引用チェック
scripts/check-references.sh reports/cloud_edge_technology_research.md
```

### Quartoの利点と詳細ガイド

#### 主要な利点
- ✅ **自動章節番号付与**: セクション番号の手動管理が不要
- ✅ **相互参照機能**: 図表・章節への自動リンク生成
- ✅ **引用管理**: BibTeX連携による自動文献リスト作成
- ✅ **多形式出力**: HTML、PDF、EPUBへの同時出力
- ✅ **レスポンシブHTML**: モバイル対応の美しいレイアウト
- ✅ **検索機能**: HTML版での高速全文検索

#### 前提条件

**Quarto CLI**（必須）:
```bash
# インストール方法
# 1. 公式サイト: https://quarto.org/docs/get-started/
# 2. または以下のコマンド（Linux）
curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
sudo dpkg -i quarto-linux-amd64.deb
```

**PDF生成用**（オプション）:
```bash
# LaTeX環境（フルインストール）
sudo apt-get install texlive-full

# または軽量版
quarto install tinytex
```

**確認**:
```bash
# Quartoバージョン確認
quarto --version

# リアルタイムプレビュー
cd reports && quarto preview cloud_edge_technology_research.qmd
```

#### Quartoファイル構造

```
reports/
├── _quarto.yml                          # プロジェクト設定
├── index.qmd                           # ポータルページ
├── cloud_edge_technology_research.qmd  # メイン報告書
├── references.bib                      # 文献データベース
└── templates/
    └── styles/
        └── report-style.css            # カスタムCSS
```

#### 主要機能の使用方法

**1. 相互参照**:
```markdown
# 章への参照
@sec-classification で示した技術分類により...

# 図表への参照
@tbl-market-forecast に示すように...
```

**2. 文献引用**:
```markdown
# インライン引用
エッジコンピューティング市場は成長している[@idc2024edge]。

# 複数引用
複数の調査[@idc2024edge; @cisco2020internet]によると...
```

**3. 図表の自動番号付与**:
```markdown
| 項目 | 値 |
|------|-----|
| 市場規模 | 143億ドル |

: 市場規模予測 {#tbl-market-forecast}
```

#### よくある問題と解決方法

**PDF生成でエラーが出る場合**:
```bash
# LaTeXログを確認
quarto render --verbose cloud_edge_technology_research.qmd --to pdf

# TinyTeXをインストール
quarto install tinytex
```

**日本語フォントが表示されない場合**:
`_quarto.yml`でフォントを指定:
```yaml
format:
  pdf:
    mainfont: "Noto Serif CJK JP"
    sansfont: "Noto Sans CJK JP"
```

**相互参照が機能しない場合**:
- IDの重複をチェック（`{#sec-id}`）
- セクションレベルの確認
- 正しい参照形式（`@sec-id`）の使用

#### 移行の利点

**Before（従来のMarkdown）**:
- ❌ 手動での章節番号管理
- ❌ 参照の手動更新
- ❌ 図表番号の手動管理
- ❌ 引用の手動フォーマット

**After（Quarto）**:
- ✅ 完全自動の番号管理
- ✅ 動的な相互参照
- ✅ 自動図表番号
- ✅ BibTeX連携引用

## AI指示書システムの活用

このプロジェクトには技術調査・分析に特化したAI指示書システムが含まれています：

### プリセット指示書（高速・推奨）
- `technical_writer.md` - 技術文書作成専門
- `academic_researcher.md` - 学術研究・分析専門
- `data_analyst.md` - データ分析・市場調査専門

### 専門指示書
- `research_analyst.md` - クラウドエッジ技術調査分析
- `report_writer.md` - 技術報告書執筆

詳細は`instructions/PROJECT.md`を参照してください。

## コントリビューション

プルリクエストを歓迎します。大きな変更の場合は、まずissueを開いて変更内容について議論してください。

## ライセンス

[Apache-2.0](LICENSE)

## サポート

問題が発生した場合は、[Issues](https://github.com/dobachi/ResearchEdgeCloudTech/issues)でお知らせください。