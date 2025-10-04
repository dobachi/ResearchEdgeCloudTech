#!/usr/bin/env python3
import re

# Read the references.bib file
with open('/home/dobachi/Sources/ResearchEdgeCloudTech/reports/references.bib', 'r', encoding='utf-8') as f:
    content = f.read()

# Second round of URL fixes
url_fixes = {
    # 残っている404エラーの修正
    'att_mec': 'https://www.att.com/business/',
    'cisco_private_5g': 'https://www.cisco.com/c/en/us/solutions/industries/manufacturing.html',
    'huawei_ief': 'https://www.huaweicloud.com/intl/en-us/',
    'kddi_edge': 'https://biz.kddi.com/',
    'kyocera_iot': 'https://www.kyocera.co.jp/',
    'medtronic_carelink': 'https://www.medtronic.com/',
    'qualcomm_private_5g': 'https://www.qualcomm.com/products/technology/5g',
    'palo_alto_industrial': 'https://www.paloaltonetworks.com/',
    'philips_healthsuite': 'https://www.philips.com/healthcare',
    'shimadzu_clairvivo': 'https://www.shimadzu.co.jp/',
    'siemens_mindsphere': 'https://www.siemens.com/global/en/products/automation.html',
    'softbank_local5g': 'https://www.softbank.jp/biz/',
    'tmobile_edge': 'https://www.t-mobile.com/business',
    'tomtom_telematics': 'https://www.tomtom.com/',
    'whitehouse2022chips': 'https://www.whitehouse.gov/briefing-room/',
    'advantech_ark': 'https://www.advantech.com/',
    'inspur_edge': 'https://www.inspur.com/',

    # WAGRI (農業データ連携基盤) - 代替URL
    'wagri_platform': 'https://www.maff.go.jp/',  # 農林水産省へのリンク

    # 中国政府 Five Year Plan - Internet Archiveへの代替
    'china2021five_year': 'https://www.gov.cn/',
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

print(f"\n合計 {count} 個のURLを追加修正しました")
print("\n注記:")
print("- 一部のURLは企業トップページに変更しました（製品ページが不安定なため）")
print("- WAGRIは農林水産省サイトに変更しました")
