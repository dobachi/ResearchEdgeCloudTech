#!/usr/bin/env python3
import re
import requests
from concurrent.futures import ThreadPoolExecutor, as_completed
import time

def extract_urls(bib_file):
    """Extract URLs from references.bib file"""
    urls = []
    cite_keys = []

    with open(bib_file, 'r', encoding='utf-8') as f:
        content = f.read()

    # Extract cite_key and URL pairs
    pattern = r'@misc\{([^,]+),.*?url = \{([^}]+)\}'
    matches = re.findall(pattern, content, re.DOTALL)

    for cite_key, url in matches:
        urls.append(url)
        cite_keys.append(cite_key)

    return cite_keys, urls

def check_url(cite_key, url, timeout=10):
    """Check if URL is accessible"""
    try:
        response = requests.head(url, timeout=timeout, allow_redirects=True)
        status = response.status_code

        # If HEAD fails, try GET
        if status >= 400:
            response = requests.get(url, timeout=timeout, allow_redirects=True)
            status = response.status_code

        return cite_key, url, status, None
    except requests.Timeout:
        return cite_key, url, 'TIMEOUT', 'Connection timeout'
    except requests.ConnectionError as e:
        return cite_key, url, 'ERROR', f'Connection error: {str(e)[:50]}'
    except Exception as e:
        return cite_key, url, 'ERROR', f'{type(e).__name__}: {str(e)[:50]}'

def main():
    bib_file = '/home/dobachi/Sources/ResearchEdgeCloudTech/reports/references.bib'

    print("Extracting URLs from references.bib...")
    cite_keys, urls = extract_urls(bib_file)

    print(f"Found {len(urls)} URLs to check\n")
    print("=" * 80)

    broken_urls = []
    valid_urls = []

    # Check URLs in parallel with ThreadPoolExecutor
    with ThreadPoolExecutor(max_workers=10) as executor:
        future_to_url = {executor.submit(check_url, cite_keys[i], urls[i]): i
                         for i in range(len(urls))}

        for i, future in enumerate(as_completed(future_to_url), 1):
            cite_key, url, status, error = future.result()

            print(f"\r[{i}/{len(urls)}] Checking...", end='', flush=True)

            if status == 200 or status == 301 or status == 302:
                valid_urls.append((cite_key, url, status))
            else:
                broken_urls.append((cite_key, url, status, error))

    print("\n" + "=" * 80)
    print(f"\n✓ Valid URLs: {len(valid_urls)}")
    print(f"✗ Broken/Unreachable URLs: {len(broken_urls)}\n")

    if broken_urls:
        print("BROKEN OR UNREACHABLE URLs:")
        print("-" * 80)
        for cite_key, url, status, error in sorted(broken_urls):
            print(f"\n[@{cite_key}]")
            print(f"  URL: {url}")
            print(f"  Status: {status}")
            if error:
                print(f"  Error: {error}")

    # Save results
    with open('/tmp/url_check_results.txt', 'w', encoding='utf-8') as f:
        f.write(f"URL Check Results\n")
        f.write(f"=" * 80 + "\n\n")
        f.write(f"Total URLs: {len(urls)}\n")
        f.write(f"Valid: {len(valid_urls)}\n")
        f.write(f"Broken: {len(broken_urls)}\n\n")

        if broken_urls:
            f.write("BROKEN URLs:\n")
            f.write("-" * 80 + "\n")
            for cite_key, url, status, error in sorted(broken_urls):
                f.write(f"\n[@{cite_key}]\n")
                f.write(f"  URL: {url}\n")
                f.write(f"  Status: {status}\n")
                if error:
                    f.write(f"  Error: {error}\n")

    print(f"\nResults saved to /tmp/url_check_results.txt")

if __name__ == "__main__":
    main()
