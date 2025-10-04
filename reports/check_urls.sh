#!/bin/bash

# Extract URLs from references.bib
urls_file="/tmp/urls_to_check.txt"
broken_urls_file="/tmp/broken_urls.txt"
valid_urls_file="/tmp/valid_urls.txt"

grep -oP 'url = \{\K[^}]+' /home/dobachi/Sources/ResearchEdgeCloudTech/reports/references.bib > "$urls_file"

# Clear output files
> "$broken_urls_file"
> "$valid_urls_file"

echo "Checking $(wc -l < "$urls_file") URLs..."
echo "========================================"

total=$(wc -l < "$urls_file")
count=0

while IFS= read -r url; do
    count=$((count + 1))
    echo -ne "\rProgress: $count/$total"

    # Check URL with curl (follow redirects, timeout 10s)
    http_code=$(curl -o /dev/null -s -w "%{http_code}" --max-time 10 -L "$url")

    if [ "$http_code" -eq 200 ] || [ "$http_code" -eq 301 ] || [ "$http_code" -eq 302 ]; then
        echo "$url [OK: $http_code]" >> "$valid_urls_file"
    else
        echo "$url [FAIL: $http_code]" >> "$broken_urls_file"
    fi
done < "$urls_file"

echo -e "\n========================================"
echo "Check complete!"
echo ""
echo "Valid URLs: $(wc -l < "$valid_urls_file")"
echo "Broken URLs: $(wc -l < "$broken_urls_file")"
echo ""

if [ -s "$broken_urls_file" ]; then
    echo "Broken URLs found:"
    cat "$broken_urls_file"
fi
