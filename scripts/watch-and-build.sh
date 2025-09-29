#!/bin/bash

# 自動ビルド・ウォッチスクリプト
# Usage: ./watch-and-build.sh [format] [interval]
# Format: html, pdf, all (default: html)
# Interval: 監視間隔（秒、デフォルト: 2）

set -e

# 設定
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
REPORTS_DIR="$PROJECT_ROOT/reports"
FORMAT="${1:-html}"
INTERVAL="${2:-2}"
LAST_BUILD=0
BUILD_LOCK="/tmp/quarto-build.lock"

# カラー出力
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# ヘルプ表示
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "自動ビルド・ウォッチスクリプト"
    echo ""
    echo "使用方法:"
    echo "  $0 [format] [interval]"
    echo ""
    echo "引数:"
    echo "  format    出力形式 (html, pdf, all) [デフォルト: html]"
    echo "  interval  監視間隔（秒） [デフォルト: 2]"
    echo ""
    echo "例:"
    echo "  $0 html 3        # HTML版を3秒間隔で監視"
    echo "  $0 pdf 5         # PDF版を5秒間隔で監視"
    echo "  $0 all 10        # 全形式を10秒間隔で監視"
    echo ""
    echo "監視対象ファイル:"
    echo "  - reports/*.qmd"
    echo "  - reports/*.yml"
    echo "  - reports/*.bib"
    echo "  - reports/templates/**"
    echo ""
    echo "停止方法: Ctrl+C"
    exit 0
fi

# 前提条件チェック
check_prerequisites() {
    echo -e "${BLUE}🔍 前提条件をチェック中...${NC}"

    # Quartoのチェック
    if ! command -v quarto &> /dev/null; then
        echo -e "${RED}❌ エラー: Quarto CLIがインストールされていません${NC}"
        echo "   インストール方法: https://quarto.org/docs/get-started/"
        exit 1
    fi

    # inotify-toolsのチェック（Linux）
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if ! command -v inotifywait &> /dev/null; then
            echo -e "${YELLOW}⚠️  警告: inotify-tools がインストールされていません（推奨）${NC}"
            echo "   インストール方法: sudo apt-get install inotify-tools"
            echo "   ポーリング方式で継続します..."
        fi
    fi

    echo -e "${GREEN}✅ 前提条件チェック完了${NC}"
}

# ファイル変更時刻の取得
get_file_mtime() {
    local max_mtime=0
    local files=(
        "$REPORTS_DIR"/*.qmd
        "$REPORTS_DIR"/*.yml
        "$REPORTS_DIR"/*.yaml
        "$REPORTS_DIR"/*.bib
        "$REPORTS_DIR"/templates/**/*
    )

    for file in "${files[@]}"; do
        if [[ -f "$file" ]]; then
            local mtime=$(stat -c %Y "$file" 2>/dev/null || stat -f %m "$file" 2>/dev/null || echo 0)
            if (( mtime > max_mtime )); then
                max_mtime=$mtime
            fi
        fi
    done

    echo $max_mtime
}

# ビルド実行
build_report() {
    local format="$1"
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')

    echo -e "${BLUE}🔨 [$timestamp] ビルドを開始...${NC}"

    # ロックファイルでビルドの重複実行を防止
    if [[ -f "$BUILD_LOCK" ]]; then
        echo -e "${YELLOW}⏳ ビルドが既に実行中です...${NC}"
        return 0
    fi

    touch "$BUILD_LOCK"

    # ビルド実行
    if "$SCRIPT_DIR/build-quarto-report.sh" "$format" > /tmp/quarto-build.log 2>&1; then
        echo -e "${GREEN}✅ [$timestamp] ビルド成功: $format${NC}"

        # 生成されたファイルの表示
        if [[ "$format" == "html" || "$format" == "all" ]]; then
            local html_files
            html_files=$(find "$PROJECT_ROOT/output/html" -name "*.html" 2>/dev/null | wc -l)
            echo -e "   📄 HTML: ${html_files}ファイル生成"
        fi

        if [[ "$format" == "pdf" || "$format" == "all" ]]; then
            local pdf_files
            pdf_files=$(find "$PROJECT_ROOT/output/pdf" -name "*.pdf" 2>/dev/null | wc -l)
            echo -e "   📑 PDF: ${pdf_files}ファイル生成"
        fi
    else
        echo -e "${RED}❌ [$timestamp] ビルド失敗${NC}"
        echo -e "${RED}エラーログ:${NC}"
        tail -10 /tmp/quarto-build.log | sed 's/^/   /'
    fi

    rm -f "$BUILD_LOCK"
}

# 監視ループ（inotify使用）
watch_with_inotify() {
    echo -e "${GREEN}🔍 inotifyでファイル監視を開始（対象: $REPORTS_DIR）${NC}"
    echo -e "${YELLOW}停止するには Ctrl+C を押してください${NC}"
    echo ""

    # 初回ビルド
    build_report "$FORMAT"

    # ファイル監視
    inotifywait -m -r -e modify,create,delete,move \
        --include '\.(qmd|yml|yaml|bib|css|js)$' \
        "$REPORTS_DIR" 2>/dev/null | while read path action file; do

        echo -e "${BLUE}📝 変更検出: $file ($action)${NC}"

        # 短時間での連続実行を防ぐ
        sleep 1

        build_report "$FORMAT"
        echo ""
    done
}

# 監視ループ（ポーリング）
watch_with_polling() {
    echo -e "${GREEN}🔍 ポーリングでファイル監視を開始（間隔: ${INTERVAL}秒）${NC}"
    echo -e "${YELLOW}停止するには Ctrl+C を押してください${NC}"
    echo ""

    LAST_BUILD=$(get_file_mtime)
    build_report "$FORMAT"

    while true; do
        sleep "$INTERVAL"

        local current_mtime
        current_mtime=$(get_file_mtime)

        if (( current_mtime > LAST_BUILD )); then
            echo -e "${BLUE}📝 変更検出 (mtime: $current_mtime > $LAST_BUILD)${NC}"
            build_report "$FORMAT"
            LAST_BUILD=$current_mtime
            echo ""
        fi
    done
}

# シグナルハンドラー
cleanup() {
    echo -e "\n${YELLOW}🛑 監視を停止中...${NC}"
    rm -f "$BUILD_LOCK"
    kill $(jobs -p) 2>/dev/null || true
    echo -e "${GREEN}✅ 監視を停止しました${NC}"
    exit 0
}

# メイン実行
main() {
    echo -e "${BLUE}🚀 クラウドエッジ技術調査報告書 自動ビルドシステム${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "📊 出力形式: ${GREEN}$FORMAT${NC}"
    echo -e "⏱️  監視間隔: ${GREEN}${INTERVAL}秒${NC}"
    echo -e "📁 監視対象: ${GREEN}$REPORTS_DIR${NC}"
    echo ""

    check_prerequisites

    # シグナルハンドラー設定
    trap cleanup SIGINT SIGTERM

    # 監視方式の選択
    if command -v inotifywait &> /dev/null && [[ "$OSTYPE" == "linux-gnu"* ]]; then
        watch_with_inotify
    else
        watch_with_polling
    fi
}

main "$@"