#!/usr/bin/env python3
import re

# Read the references.bib file
with open('/home/dobachi/Sources/ResearchEdgeCloudTech/reports/references.bib', 'r', encoding='utf-8') as f:
    content = f.read()

# Fifth round of URL fixes - Remaining unfixed errors (user confirmed these don't work)
url_fixes = {
    # Gartner IIoT Platforms - 代替URL（全般ページ）
    'gartner_iiot_platforms_2024': 'https://www.gartner.com/en/documents/5389163',

    # IDC Japan Cloud Market - 代替URL（報道発表トップページ）
    'idc_japan2025cloud': 'https://www.idc.com/getdoc.jsp?containerId=prJPJ50993923',

    # STL Partners - 一般的なEdge Computingページ（中国市場記事は403）
    'stlpartners2024china_edge': 'https://stlpartners.com/edge-computing/',

    # Ericsson Private 5G - 正しい製品ページ
    'ericsson_private_5g': 'https://www.ericsson.com/en/private-networks/ericsson-private-5g',

    # GE Healthcare Edison - Digital Pharma Solutionsページ
    'ge_healthcare_edison': 'https://www.gehealthcare.com/products/digital-pharma-solutions',

    # Nokia Industrial 5G - 正しい製品ページ
    'nokia_industrial_5g': 'https://www.nokia.com/networks/industry-solutions/private-wireless/',

    # ZTE Private 5G - 正しい製品ページ
    'zte_private_5g': 'https://www.zte.com.cn/global/hottopics/5g_private_network.html',

    # 富士通HOPE - 病院向けソリューショントップページ
    'fujitsu_hope': 'https://www.fujitsu.com/jp/solutions/industry/healthcare/hospital-sol/',

    # 大林組BIM - BIM技術ページ
    'obayashi_bim': 'https://www.obayashi.co.jp/solution_technology/productivity/index031.html',

    # METI標準化人材育成 - ヤンプログラム
    'meti_hyoujun_jinzai': 'https://www.meti.go.jp/policy/economy/hyojun-kijun/katsuyo/young-professional/index.html',

    # ABB Ability - すでに修正済みだが念のため確認
    # 'abb_ability': 'https://global.abb/topic/ability/en',

    # Haier COSMOPlat - 英語版公式サイト
    'haier_cosmoplat': 'https://www.haier.com/global/haier-ecosystem/cosmoplat/',

    # STMicroelectronics IoT - IoTアプリケーションページ
    'stmicroelectronics': 'https://www.st.com/en/applications/iot-applications.html',

    # Envision Digital - EnOSプラットフォームページ
    'envision_digital': 'https://www.envision-digital.com/enos-platform/',

    # Horizon Robotics - 英語版公式サイト
    'horizon_robotics': 'https://en.horizon.auto/',

    # Limelight/Edgio - 2024年倒産のため親会社Wikipediaページ
    'limelight': 'https://en.wikipedia.org/wiki/Edgio',

    # Trend Micro TXOne - TXOne Networks公式サイト
    'trendmicro_txone': 'https://www.txone.com/',
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

print(f"\n合計 {count} 個のURLを修正しました（残存エラー対応）")
print("\n注記:")
print("- Ericsson Private 5G: 正しい製品ページに修正")
print("- GE Healthcare Edison: Digital Pharma Solutionsページに修正")
print("- Nokia Industrial 5G: Industry Solutions製品ページに修正")
print("- ZTE Private 5G: Hot Topics製品ページに修正")
print("- 富士通HOPE: 病院向けソリューショントップに修正")
print("- 大林組BIM: BIM技術ページに修正")
print("- METI標準化人材: ヤングプロフェッショナルプログラムに修正")
print("- Haier COSMOPlat: グローバルエコシステムページに修正")
print("- STMicroelectronics: IoTアプリケーションページに修正")
print("- Envision Digital: EnOSプラットフォームページに修正")
print("- Horizon Robotics: 英語版公式サイトに修正")
print("- Limelight: EdgioのWikipediaページに修正（2024年倒産）")
print("- Trend Micro TXOne: TXOne Networks公式サイトに修正")
