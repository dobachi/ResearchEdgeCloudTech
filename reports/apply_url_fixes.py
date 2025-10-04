#!/usr/bin/env python3
import re

# Read the references.bib file
with open('/home/dobachi/Sources/ResearchEdgeCloudTech/reports/references.bib', 'r', encoding='utf-8') as f:
    content = f.read()

# URL fixes (cite_key -> new_url)
url_fixes = {
    'azure_edge_zones': 'https://azure.microsoft.com/en-us/solutions/private-multi-access-edge-compute-mec/',
    'siemens_mindsphere': 'https://www.siemens.com/global/en/products/automation/industrial-edge.html',
    'siemens_healthineers': 'https://www.siemens-healthineers.com/en-us',
    'siemens_private_networks': 'https://www.siemens.com/global/en/products/automation/industrial-communication.html',
    'schneider_ecostruxure': 'https://www.se.com/ww/en/work/campaign/innovation/platform.jsp',
    'cisco_private_5g': 'https://www.cisco.com/c/en/us/solutions/industries/manufacturing/private-5g.html',
    'cisco_industrial_ethernet': 'https://www.cisco.com/c/en/us/solutions/industries/manufacturing.html',
    'dell_edge_gateway': 'https://www.dell.com/en-us/lp/internet-of-things',
    'att_mec': 'https://www.att.com/business/solutions/5g/',
    'tmobile_edge': 'https://www.t-mobile.com/business/solutions/advanced-network-solutions/5g',
    'huawei_cloud_iot': 'https://www.huaweicloud.com/intl/en-us/product/iotda.html',
    'huawei_ief': 'https://www.huaweicloud.com/intl/en-us/product/ief/',
    'kddi_edge': 'https://biz.kddi.com/service/5g/',
    'softbank_local5g': 'https://www.softbank.jp/biz/services/mobile/local5g/',
    'kubota_ksas': 'https://ksas.kubota.co.jp/',
    'kyocera_iot': 'https://www.kyocera.co.jp/prdct/telecom/',
    'kajima_a4csel': 'https://www.kajima.co.jp/tech/',
    'obayashi_bim': 'https://www.obayashi.co.jp/technology/',
    'shimadzu_clairvivo': 'https://www.shimadzu.co.jp/products/medical/',
    'qualcomm_private_5g': 'https://www.qualcomm.com/products/technology/5g',
    'vodafone_edge': 'https://www.vodafone.com/business/iot',
    'deutsche_telekom_mec': 'https://geschaeftskunden.telekom.de/digitalisierung',
    'deutsche_telekom_edge_cloud': 'https://geschaeftskunden.telekom.de/digitalisierung',
    'tomtom_telematics': 'https://www.tomtom.com/products/geolocation/',
    'inspur_edge': 'https://www.inspur.com/en/',
    'philips_healthsuite': 'https://www.philips.com/a-w/about/innovation/health-technology.html',
    'palo_alto_industrial': 'https://www.paloaltonetworks.com/solutions/industrial-security',
    'medtronic_carelink': 'https://www.medtronic.com/us-en/patients/treatments-therapies/cardiac-rhythm-disease/your-heart-device/remote-monitoring.html',
    'midea_iot': 'https://www.midea.com/global/about-midea',
    'kapsch_trafficcom': 'https://www.kapsch.net/',
    'advantech_ark': 'https://www.advantech.com/en/products/industrial-automation-systems/industrial-computers',
}

# Title updates (cite_key -> new_title)
title_updates = {
    'azure_edge_zones': 'Microsoft Azure Private MEC (旧Edge Zones)',
}

count = 0
for cite_key, new_url in url_fixes.items():
    # Pattern to match the entire @misc{cite_key,...} block
    pattern = r'(@misc\{' + re.escape(cite_key) + r',.*?url = \{)[^}]+(}.*?})'

    def replace_url(match):
        return match.group(1) + new_url + match.group(2)

    new_content = re.sub(pattern, replace_url, content, flags=re.DOTALL)

    if new_content != content:
        count += 1
        print(f"✓ Fixed URL for [@{cite_key}]")
        content = new_content

# Update titles
for cite_key, new_title in title_updates.items():
    pattern = r'(@misc\{' + re.escape(cite_key) + r',\s*title = \{)[^}]+(},)'

    def replace_title(match):
        return match.group(1) + new_title + match.group(2)

    new_content = re.sub(pattern, replace_title, content)

    if new_content != content:
        print(f"✓ Updated title for [@{cite_key}]")
        content = new_content

# Write back to file
with open('/home/dobachi/Sources/ResearchEdgeCloudTech/reports/references.bib', 'w', encoding='utf-8') as f:
    f.write(content)

print(f"\n合計 {count} 個のURLを修正しました")
