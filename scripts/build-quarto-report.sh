#!/bin/bash

# Quartoベース調査報告書ビルドスクリプト
# Usage: ./build-quarto-report.sh [format] [output_dir]
# Format: html, pdf, all (default: html)
# Output: 指定されたディレクトリまたはデフォルトの出力先

set -e

# 設定
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
REPORTS_DIR="$PROJECT_ROOT/reports"
DEFAULT_OUTPUT_DIR="$PROJECT_ROOT/output"

# 引数の処理
FORMAT="${1:-html}"
OUTPUT_DIR="${2:-$DEFAULT_OUTPUT_DIR}"

# ヘルプ表示
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "クラウドエッジ技術調査報告書 Quartoビルドスクリプト"
    echo ""
    echo "使用方法:"
    echo "  $0 [format] [output_dir]"
    echo ""
    echo "引数:"
    echo "  format      出力形式 (html, pdf, all) [デフォルト: html]"
    echo "  output_dir  出力ディレクトリ [デフォルト: $DEFAULT_OUTPUT_DIR]"
    echo ""
    echo "例:"
    echo "  $0 html                    # HTML版を生成"
    echo "  $0 pdf                     # PDF版を生成"
    echo "  $0 all                     # 全形式を生成"
    echo "  $0 html /tmp/reports       # 指定ディレクトリにHTML版を生成"
    echo ""
    echo "必要な環境:"
    echo "  - Quarto CLI (https://quarto.org/)"
    echo "  - Pandoc (Quartoに含まれる)"
    echo "  - LaTeX (PDF生成時のみ)"
    exit 0
fi

# 前提条件のチェック
echo "🔍 前提条件をチェック中..."

# Quartoのチェック
if ! command -v quarto &> /dev/null; then
    echo "❌ エラー: Quarto CLIがインストールされていません"
    echo "   インストール方法: https://quarto.org/docs/get-started/"
    exit 1
fi

echo "✅ Quarto CLI: $(quarto --version)"

# LaTeXのチェック（PDF生成時のみ）
if [[ "$FORMAT" == "pdf" || "$FORMAT" == "all" ]]; then
    if ! command -v pdflatex &> /dev/null; then
        echo "⚠️  警告: LaTeXがインストールされていません（PDF生成に必要）"
        echo "   インストール方法（Ubuntu/Debian）: sudo apt-get install texlive-full"
        echo "   インストール方法（macOS）: brew install --cask mactex"
        echo "   代替: Quarto install tinytex"

        if [[ "$FORMAT" == "pdf" ]]; then
            exit 1
        fi
    fi
fi

# ディレクトリの作成
echo "📁 出力ディレクトリを準備中..."
mkdir -p "$OUTPUT_DIR"
mkdir -p "$OUTPUT_DIR/html"
mkdir -p "$OUTPUT_DIR/pdf"

# レポートディレクトリに移動
cd "$REPORTS_DIR"

# ビルド実行
echo "🔨 Quartoドキュメントをビルド中..."

case "$FORMAT" in
    "html")
        echo "📄 HTML版を生成中..."
        quarto render cloud_edge_technology_research.qmd --to html --output-dir "$OUTPUT_DIR/html"
        echo "✅ HTML版の生成完了: $OUTPUT_DIR/html/"
        ;;
    "pdf")
        echo "📑 PDF版を生成中..."
        quarto render cloud_edge_technology_research.qmd --to pdf --output-dir "$OUTPUT_DIR/pdf"
        echo "✅ PDF版の生成完了: $OUTPUT_DIR/pdf/"
        ;;
    "all")
        echo "📄 HTML版を生成中..."
        quarto render cloud_edge_technology_research.qmd --to html --output-dir "$OUTPUT_DIR/html"
        echo "✅ HTML版の生成完了"

        echo "📑 PDF版を生成中..."
        quarto render cloud_edge_technology_research.qmd --to pdf --output-dir "$OUTPUT_DIR/pdf"
        echo "✅ PDF版の生成完了"

        echo "✅ 全形式の生成完了: $OUTPUT_DIR/"
        ;;
    *)
        echo "❌ エラー: 未対応の形式 '$FORMAT'"
        echo "   対応形式: html, pdf, all"
        exit 1
        ;;
esac

# 生成結果の表示
echo ""
echo "🎉 ビルド完了！"
echo ""
echo "生成されたファイル:"
if [[ "$FORMAT" == "html" || "$FORMAT" == "all" ]]; then
    find "$OUTPUT_DIR/html" -name "*.html" -exec echo "  📄 {}" \;
fi
if [[ "$FORMAT" == "pdf" || "$FORMAT" == "all" ]]; then
    find "$OUTPUT_DIR/pdf" -name "*.pdf" -exec echo "  📑 {}" \;
fi

echo ""
echo "👀 ブラウザで確認:"
if [[ "$FORMAT" == "html" || "$FORMAT" == "all" ]]; then
    HTML_FILE="$OUTPUT_DIR/html/cloud_edge_technology_research.html"
    if [[ -f "$HTML_FILE" ]]; then
        echo "  file://$HTML_FILE"
    fi
fi

echo ""
echo "📊 レポート概要:"
echo "  - 技術分類: 6カテゴリ分析"
echo "  - 市場予測: 2030年まで"
echo "  - 戦略提言: 短期・中期・長期"
echo "  - 相互参照: 自動章節番号付与"
echo "  - 引用管理: 自動文献リスト生成"