#!/bin/bash

# 継続ビルド+Webサーバー統合スクリプト
# Usage: ./serve-and-watch.sh [port] [format]
# Port: ポート番号 (デフォルト: 8080)
# Format: html, pdf, all (デフォルト: html)

set -e

# 設定
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
REPORTS_DIR="$PROJECT_ROOT/reports"
OUTPUT_DIR="$PROJECT_ROOT/output"
PORT="${1:-8080}"
FORMAT="${2:-html}"

# カラー出力
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ヘルプ表示
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    echo "継続ビルド+Webサーバー統合スクリプト"
    echo ""
    echo "使用方法:"
    echo "  $0 [port] [format]"
    echo ""
    echo "引数:"
    echo "  port      ポート番号 [デフォルト: 8080]"
    echo "  format    出力形式 (html, pdf, all) [デフォルト: html]"
    echo ""
    echo "機能:"
    echo "  - ファイル変更の自動監視"
    echo "  - 自動ビルド実行"
    echo "  - ローカルWebサーバー起動"
    echo "  - ブラウザ自動リフレッシュ（Quarto preview使用時）"
    echo ""
    echo "例:"
    echo "  $0 3333 html        # ポート3333でHTML版をサーブ"
    echo "  $0 8080 all         # ポート8080で全形式をビルド"
    echo ""
    echo "アクセス方法:"
    echo "  - Quarto preview: http://localhost:[port] (自動リフレッシュ)"
    echo "  - 静的サーバー: http://localhost:[port] (手動リフレッシュ)"
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
        exit 1
    fi

    # Pythonのチェック（静的サーバー用）
    if ! command -v python3 &> /dev/null; then
        echo -e "${YELLOW}⚠️  警告: Python3がインストールされていません（静的サーバー用）${NC}"
    fi

    echo -e "${GREEN}✅ 前提条件チェック完了${NC}"
}

# プロセス管理用変数
QUARTO_PID=""
STATIC_SERVER_PID=""
WATCH_PID=""

# クリーンアップ関数
cleanup() {
    echo -e "\n${YELLOW}🛑 サーバーを停止中...${NC}"

    if [[ -n "$QUARTO_PID" ]]; then
        kill $QUARTO_PID 2>/dev/null || true
        echo -e "${GREEN}✅ Quartoプレビューサーバーを停止${NC}"
    fi

    if [[ -n "$STATIC_SERVER_PID" ]]; then
        kill $STATIC_SERVER_PID 2>/dev/null || true
        echo -e "${GREEN}✅ 静的サーバーを停止${NC}"
    fi

    if [[ -n "$WATCH_PID" ]]; then
        kill $WATCH_PID 2>/dev/null || true
        echo -e "${GREEN}✅ ファイル監視を停止${NC}"
    fi

    # 子プロセスをすべて終了
    kill $(jobs -p) 2>/dev/null || true

    echo -e "${GREEN}✅ すべてのサーバーを停止しました${NC}"
    exit 0
}

# シグナルハンドラー設定
trap cleanup SIGINT SIGTERM

# Quartoプレビューサーバー起動
start_quarto_preview() {
    echo -e "${CYAN}🚀 Quartoプレビューサーバーを起動中...${NC}"
    echo -e "${BLUE}📍 URL: http://localhost:$PORT${NC}"
    echo -e "${BLUE}📁 対象: $REPORTS_DIR${NC}"
    echo ""

    cd "$REPORTS_DIR"
    quarto preview --port "$PORT" --host 0.0.0.0 --no-browser &
    QUARTO_PID=$!

    # サーバー起動待機
    sleep 3
    echo -e "${GREEN}✅ Quartoプレビューサーバー起動完了${NC}"
    echo -e "${CYAN}🌐 ブラウザで http://localhost:$PORT にアクセスしてください${NC}"
}

# 静的Webサーバー起動
start_static_server() {
    echo -e "${CYAN}🚀 静的Webサーバーを起動中...${NC}"
    echo -e "${BLUE}📍 URL: http://localhost:$PORT${NC}"
    echo -e "${BLUE}📁 対象: $OUTPUT_DIR/html${NC}"
    echo ""

    cd "$OUTPUT_DIR/html"
    python3 -m http.server "$PORT" --bind 0.0.0.0 > /dev/null 2>&1 &
    STATIC_SERVER_PID=$!

    # サーバー起動待機
    sleep 2
    echo -e "${GREEN}✅ 静的Webサーバー起動完了${NC}"
    echo -e "${CYAN}🌐 ブラウザで http://localhost:$PORT にアクセスしてください${NC}"
}

# ファイル監視+ビルド
start_file_watcher() {
    echo -e "${CYAN}🔍 ファイル監視+自動ビルドを開始...${NC}"

    "$SCRIPT_DIR/watch-and-build.sh" "$FORMAT" &
    WATCH_PID=$!

    echo -e "${GREEN}✅ ファイル監視開始${NC}"
}

# メイン実行
main() {
    echo -e "${BLUE}🚀 クラウドエッジ技術調査報告書 開発サーバー${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${CYAN}📊 ポート: ${GREEN}$PORT${NC}"
    echo -e "${CYAN}📄 形式: ${GREEN}$FORMAT${NC}"
    echo -e "${CYAN}📁 監視対象: ${GREEN}$REPORTS_DIR${NC}"
    echo ""

    check_prerequisites

    # 出力ディレクトリの準備
    mkdir -p "$OUTPUT_DIR/html"
    mkdir -p "$OUTPUT_DIR/pdf"

    # 初回ビルド
    echo -e "${BLUE}🔨 初回ビルドを実行中...${NC}"
    "$SCRIPT_DIR/build-quarto-report.sh" "$FORMAT"

    # Quartoプレビューサーバーを起動
    if command -v quarto &> /dev/null; then
        echo ""
        start_quarto_preview
    else
        echo -e "${RED}❌ エラー: Quarto CLIが見つかりません${NC}"
        exit 1
    fi

    echo ""
    echo -e "${GREEN}🎉 開発サーバー起動完了！${NC}"
    echo ""
    echo -e "${CYAN}📋 利用可能な機能:${NC}"
    echo -e "   🔄 自動ファイル監視"
    echo -e "   🔨 自動ビルド実行"
    echo -e "   🌐 ローカルWebサーバー"
    if [[ -n "$QUARTO_PID" ]]; then
        echo -e "   ✨ 自動ブラウザリフレッシュ"
    fi
    echo ""
    echo -e "${YELLOW}停止するには Ctrl+C を押してください${NC}"

    # サーバーを待機
    if [[ -n "$QUARTO_PID" ]]; then
        wait $QUARTO_PID
    else
        while true; do
            sleep 1
        done
    fi
}

main "$@"