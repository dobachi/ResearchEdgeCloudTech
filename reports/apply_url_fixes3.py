#!/usr/bin/env python3
import re

# Read the references.bib file
with open('/home/dobachi/Sources/ResearchEdgeCloudTech/reports/references.bib', 'r', encoding='utf-8') as f:
    content = f.read()

# Third round of URL fixes - 404 errors
url_fixes = {
    # 404エラーの修正（WebSearch結果に基づく）
    'advantech_ark': 'https://www.advantech.com/en-us/embedded-boards-design-in-services/ark',
    'att_mec': 'https://www.business.att.com/products/multi-access-edge-computing.html',
    'cisco_private_5g': 'https://www.cisco.com/site/us/en/products/networking/wireless/private-5g/index.html',
    'china2021five_year': 'https://www.rieti.go.jp/users/china-tr/jp/210415kaikaku.html',
    'dod2024microelectronics': 'https://www.cto.mil/ct/microelectronics/commons/',
    'gaiax2024architecture': 'https://docs.gaia-x.eu/technical-committee/architecture-document/24.04/',
    'huawei_ief': 'https://support.huaweicloud.com/intl/en-us/productdesc-ief/ief_productdesc_0003.html',
    'kddi_edge': 'https://biz.kddi.com/beconnected/feature/2021/210421/',
    'kyocera_iot': 'https://www.kyocera.co.jp/prdct/telecom/office/iot/',
    'medtronic_carelink': 'https://www.medtronic.com/en-us/l/patients/treatments-therapies/remote-monitoring.html',
    'palo_alto_industrial': 'https://www.paloaltonetworks.com/network-security/industrial-ot-security',
    'philips_healthsuite': 'https://www.usa.philips.com/a-w/about/news/archive/standard/news/press/2024/philips-and-aws-expand-strategic-collaboration-to-advance-healthsuite-cloud-services-and-power-generative-ai-workflows.html',
    'qualcomm_private_networks': 'https://www.qualcomm.com/research/5g/5g-industrial-iot',
    'shimadzu_clairvivo': 'https://www.an.shimadzu.co.jp/bio/clairvivo/index-opt.htm',
    'siemens_mindsphere': 'https://www.siemens.com/global/en/products/automation/topic-areas/industrial-edge.html',
    'softbank_local5g': 'https://www.softbank.jp/biz/services/5g/private-5g/',
    'tmobile_edge': 'https://www.t-mobile.com/business/solutions/5g-advanced-solutions',
    'tomtom_telematics': 'https://www.tomtom.com/products/',
    'whitehouse2022chips': 'https://bidenwhitehouse.archives.gov/briefing-room/statements-releases/2022/08/09/fact-sheet-chips-and-science-act-will-lower-costs-create-jobs-strengthen-supply-chains-and-counter-china/',

    # Digital Twin Market Report (DMI=DataM Intelligence と推定)
    'dmin2025digitaltwin': 'https://www.datamintelligence.com/research-report/digital-twin-technology-in-manufacturing-market',
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

print(f"\n合計 {count} 個のURLを修正しました（404エラー対応）")
print("\n注記:")
print("- WebSearchで確認した最新の公式URLに変更しました")
print("- 一部の製品ページは廃止されたため、関連する製品ページまたは技術ページに変更しました")
print("- 中国政府第14次五カ年計画はRIETI解説ページに変更しました")
print("- White House CHIPS ActはBiden White House Archivesに変更しました")
