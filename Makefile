# クラウドエッジ技術調査報告書 Makefile

# 設定
REPORTS_DIR = reports
OUTPUT_DIR = output
SCRIPTS_DIR = scripts

# デフォルトターゲット
.DEFAULT_GOAL := html

# ヘルプ表示
.PHONY: help
help: ## このヘルプメッセージを表示
	@echo "クラウドエッジ技術調査報告書 ビルドシステム"
	@echo ""
	@echo "使用可能なタスク:"
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)
	@echo ""
	@echo "例:"
	@echo "  make html      # HTML版を生成"
	@echo "  make pdf       # PDF版を生成"
	@echo "  make all       # 全形式を生成"
	@echo "  make serve     # 開発サーバー起動（継続ビルド+Webサーバー）"
	@echo "  make preview   # Quartoプレビューサーバー起動"
	@echo "  make watch     # 自動ビルド監視のみ"
	@echo "  make clean     # 生成ファイルを削除"

# 前提条件チェック
.PHONY: check
check: ## 前提条件をチェック
	@echo "🔍 前提条件をチェック中..."
	@command -v quarto >/dev/null 2>&1 || (echo "❌ Quarto CLI が見つかりません" && exit 1)
	@echo "✅ Quarto: $$(quarto --version)"
	@test -f $(REPORTS_DIR)/cloud_edge_technology_research.qmd || (echo "❌ メイン報告書が見つかりません" && exit 1)
	@test -f $(REPORTS_DIR)/_quarto.yml || (echo "❌ Quarto設定ファイルが見つかりません" && exit 1)
	@test -f $(REPORTS_DIR)/references.bib || (echo "❌ 参考文献ファイルが見つかりません" && exit 1)
	@echo "✅ 全ての前提条件をクリア"

# 図表生成
.PHONY: generate-images
generate-images: ## SVG図表を生成
	@echo "🎨 SVG図表を生成中..."
	@command -v node >/dev/null 2>&1 || (echo "❌ Node.js が見つかりません" && exit 1)
	@test -f package.json || (echo "❌ package.json が見つかりません" && exit 1)
	@npm install --silent
	@npm run generate-svg
	@echo "✅ SVG図表生成完了: reports/images/"

# 図表強制生成（手動編集を上書き）
.PHONY: generate-images-force
generate-images-force: ## SVG図表を強制生成（手動編集を上書き）
	@echo "⚠️  手動編集されたSVGを上書きします..."
	@npm run generate-svg
	@echo "✅ SVG図表強制生成完了"

# HTML版生成
.PHONY: html
html: check ## HTML版を生成
	@echo "📄 HTML版を生成中..."
	@cd $(REPORTS_DIR) && quarto render
	@echo "✅ HTML版生成完了: $(REPORTS_DIR)/_book/"
	@echo "出力先: $(REPORTS_DIR)/_book/index.html"

# PDF版生成
.PHONY: pdf
pdf: check ## PDF版を生成
	@echo "📑 PDF版を生成中..."
	@cd $(REPORTS_DIR) && quarto render --to pdf
	@echo "✅ PDF版生成完了: $(REPORTS_DIR)/_book/"
	@echo "出力先: $(REPORTS_DIR)/_book/クラウドエッジ技術に関する調査報告書.pdf"

# EPUB版生成
.PHONY: epub
epub: check ## EPUB版を生成
	@echo "📱 EPUB版を生成中..."
	@cd $(REPORTS_DIR) && quarto render --to epub
	@echo "✅ EPUB版生成完了: $(REPORTS_DIR)/_book/"
	@echo "出力先: $(REPORTS_DIR)/_book/クラウドエッジ技術に関する調査報告書.epub"

# 全形式生成
.PHONY: all
all: check ## 全形式（HTML/PDF/EPUB）を生成
	@echo "📊 全形式を生成中..."
	@cd $(REPORTS_DIR) && quarto render
	@echo "✅ 全形式生成完了: $(REPORTS_DIR)/_book/"
	@echo ""
	@echo "出力ファイル:"
	@ls -lh $(REPORTS_DIR)/_book/*.html $(REPORTS_DIR)/_book/*.pdf $(REPORTS_DIR)/_book/*.epub 2>/dev/null || true

# プレビュー
.PHONY: preview
preview: check ## リアルタイムプレビューを開始
	@echo "👀 リアルタイムプレビューを開始..."
	@echo "ブラウザで http://localhost:3333 にアクセス"
	@echo "停止するには Ctrl+C を押してください"
	@cd $(REPORTS_DIR) && quarto preview --port 3333

# 開発サーバー
.PHONY: serve
serve: check ## 継続ビルド+Webサーバーを開始（ポート8080）
	@echo "🚀 開発サーバーを開始..."
	@$(SCRIPTS_DIR)/serve-and-watch.sh 8080 html

# 開発サーバー（カスタムポート）
.PHONY: serve-port
serve-port: check ## 継続ビルド+Webサーバーを開始（カスタムポート）
	@echo "🚀 開発サーバーを開始..."
	@read -p "ポート番号を入力してください [8080]: " port; \
	port=$${port:-8080}; \
	$(SCRIPTS_DIR)/serve-and-watch.sh $$port html

# 開発サーバー（全形式）
.PHONY: serve-all
serve-all: check ## 継続ビルド+Webサーバーを開始（全形式対応）
	@echo "🚀 開発サーバーを開始（全形式）..."
	@$(SCRIPTS_DIR)/serve-and-watch.sh 8080 all

# 自動ビルド監視
.PHONY: watch
watch: check ## ファイル変更を監視して自動ビルド
	@echo "🔍 ファイル監視による自動ビルドを開始..."
	@$(SCRIPTS_DIR)/watch-and-build.sh html

# 自動ビルド監視（PDF）
.PHONY: watch-pdf
watch-pdf: check ## ファイル変更を監視してPDF自動ビルド
	@echo "🔍 ファイル監視によるPDF自動ビルドを開始..."
	@$(SCRIPTS_DIR)/watch-and-build.sh pdf

# クリーンアップ
.PHONY: clean
clean: ## 生成ファイルを削除
	@echo "🧹 生成ファイルをクリーンアップ中..."
	@rm -rf $(REPORTS_DIR)/_book/
	@rm -rf $(REPORTS_DIR)/*_files/
	@rm -f /tmp/quarto-build.log
	@rm -f /tmp/quarto-build.lock
	@echo "✅ クリーンアップ完了"

# 深いクリーンアップ
.PHONY: distclean
distclean: clean ## 全ての生成ファイル・キャッシュを削除
	@echo "🧹 深いクリーンアップ中..."
	@rm -rf $(REPORTS_DIR)/.quarto/
	@rm -rf $(REPORTS_DIR)/_freeze/
	@rm -rf .quarto/
	@rm -rf _freeze/
	@echo "✅ 深いクリーンアップ完了"

# 品質チェック
.PHONY: lint
lint: check ## ドキュメントの品質チェック
	@echo "🔍 品質チェック実行中..."
	@cd $(REPORTS_DIR) && quarto render cloud_edge_technology_research.qmd --to html --output-dir ../temp-validation >/dev/null 2>&1
	@rm -rf temp-validation
	@echo "✅ Quartoドキュメント検証: OK"
	@python3 -c "import re; content=open('$(REPORTS_DIR)/references.bib','r').read(); entries=re.findall(r'^@\w+\{', content, re.MULTILINE); print(f'✅ BibTeX検証: {len(entries)}エントリ検出') if entries else exit(1)"

# 統計情報
.PHONY: stats
stats: ## 報告書の統計情報を表示
	@echo "📊 報告書統計情報"
	@echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	@echo "📄 Quartoファイル数: $$(find $(REPORTS_DIR) -name '*.qmd' | wc -l)"
	@echo "📚 BibTeX文献数: $$(grep -c '^@' $(REPORTS_DIR)/references.bib || echo 0)"
	@echo "📝 総行数: $$(cat $(REPORTS_DIR)/*.qmd | wc -l)"
	@echo "🔤 総文字数: $$(cat $(REPORTS_DIR)/*.qmd | wc -c)"
	@if [ -d $(OUTPUT_DIR) ]; then \
		echo "💾 生成ファイルサイズ: $$(du -sh $(OUTPUT_DIR) | cut -f1)"; \
	fi

# 開発環境セットアップ
.PHONY: setup
setup: ## 開発環境をセットアップ
	@echo "⚙️  開発環境セットアップ中..."
	@mkdir -p $(OUTPUT_DIR)/html
	@mkdir -p $(OUTPUT_DIR)/pdf
	@chmod +x $(SCRIPTS_DIR)/*.sh
	@echo "✅ 開発環境セットアップ完了"

# GitHub Pages用ビルド
.PHONY: pages
pages: html ## GitHub Pages用にビルド
	@echo "🌐 GitHub Pages用にビルド中..."
	@cp -r $(OUTPUT_DIR)/html/* $(OUTPUT_DIR)/ 2>/dev/null || true
	@echo "✅ GitHub Pages用ビルド完了"

# 依存関係インストール（Ubuntu/Debian）
.PHONY: install-deps
install-deps: ## 依存関係をインストール（Ubuntu/Debian）
	@echo "📦 依存関係をインストール中..."
	@sudo apt-get update
	@sudo apt-get install -y \
		pandoc \
		texlive-latex-base \
		texlive-latex-recommended \
		texlive-latex-extra \
		texlive-fonts-recommended \
		texlive-fonts-extra \
		texlive-xetex \
		fonts-noto-cjk \
		fonts-noto-cjk-extra \
		inotify-tools
	@echo "✅ 依存関係インストール完了"

# Quartoインストール
.PHONY: install-quarto
install-quarto: ## Quarto CLIをインストール
	@echo "📥 Quarto CLIをインストール中..."
	@curl -LO https://quarto.org/download/latest/quarto-linux-amd64.deb
	@sudo dpkg -i quarto-linux-amd64.deb
	@rm quarto-linux-amd64.deb
	@quarto --version
	@echo "✅ Quarto CLIインストール完了"

# フル環境セットアップ
.PHONY: bootstrap
bootstrap: install-deps install-quarto setup ## フル環境セットアップ
	@echo "🚀 フル環境セットアップ完了！"
	@echo ""
	@echo "次のコマンドを試してください:"
	@echo "  make html     # HTML版生成"
	@echo "  make preview  # リアルタイムプレビュー"
	@echo "  make watch    # 自動ビルド監視"