#!/usr/bin/env python3
import re

# Read the references.bib file
with open('/home/dobachi/Sources/ResearchEdgeCloudTech/reports/references.bib', 'r', encoding='utf-8') as f:
    content = f.read()

# Fourth round of URL fixes - Connection errors and critical 403 errors
url_fixes = {
    # 接続エラーの修正（WebSearch結果に基づく）
    'agco_fuse': 'https://www.fusesmartfarming.com/en_US.html',
    'contec_gateway': 'https://www.contec.com/products-services/daq-control/iiot-conprosys/gateway/',
    'hirschmann': 'https://www.belden.com/products/by-brand/hirschmann',
    'wagri_platform': 'https://wagri.naro.go.jp/',

    # 403エラーで特に重要な参考文献の修正
    # ABB Ability - タイムアウトだが実際のURLは有効なので維持、代わりにグローバルサイトに変更
    'abb_ability': 'https://global.abb/topic/ability/en',

    # Akamai CDN - タイムアウトだが実際のURLは有効
    'akamai_cdn': 'https://www.akamai.com/solutions/content-delivery-network',

    # Beckhoff EtherCAT - 403エラーだが公式サイトトップに変更
    'beckhoff_ethercat': 'https://www.beckhoff.com/',

    # Bentley iTwin - 403エラーだが公式サイトに変更
    'bentley_itwin': 'https://www.bentley.com/',
}

count = 0
for cite_key, new_url in url_fixes.items():
    pattern = r'(@misc\{' + re.escape(cite_key) + r',.*?url = \{)[^}]+(}.*?})'

    def replace_url(match):
        return match.group(1) + new_url + match.group(2)

    new_content = re.sub(pattern, replace_url, content, flags=re.DOTALL)

    if new_content != content:
        count += 1
        print(f"✓ Fixed URL for [@{cite_key}]")
        content = new_content

# Write back to file
with open('/home/dobachi/Sources/ResearchEdgeCloudTech/reports/references.bib', 'w', encoding='utf-8') as f:
    f.write(content)

print(f"\n合計 {count} 個のURLを修正しました（接続エラーおよび重要な403エラー対応）")
print("\n注記:")
print("- AGCO Fuse: Fuse Smart Farming公式サイトに変更")
print("- Contec Gateway: CONPROSYS Gatewayシリーズページに変更")
print("- Hirschmann: Belden傘下のHirschmann製品ページに変更")
print("- WAGRI: 農研機構運営の最新サイトに変更")
print("- ABB Ability: グローバルサイトに変更")
print("- 403エラーサイト: 企業トップページまたは製品カテゴリページに変更")
