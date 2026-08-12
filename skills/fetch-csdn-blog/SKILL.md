---
name: fetch-csdn-blog
description: Scrape a CSDN user's blog page, list their latest articles, and update the Recent Blog feed section in README.md. Use when the user wants to refresh the blog feed in their GitHub profile README, fetch recent CSDN articles, or re-run the `<!-- feed start -->` to `<!-- feed end -->` block.
---

# Fetch CSDN Blog

Fetches the latest articles from a CSDN blog and writes them into the `<!-- feed start -->` … `<!-- feed end -->` block in README.md.

## Why

CSDN's RSS endpoint (`/rss/list`) returns an anti-bot JavaScript challenge page, so RSS feeds don't work. Scraping the blog HTML directly is the reliable way.

## Quick start

```powershell
# Fetch top 5 articles and update README.md
powershell -ExecutionPolicy Bypass -File skills/fetch-csdn-blog/scripts/fetch-csdn-blog.ps1

# Custom user / count
powershell -ExecutionPolicy Bypass -File skills/fetch-csdn-blog/scripts/fetch-csdn-blog.ps1 -Username "qq_58062502" -Count 5 -ReadmePath "README.md"
```

## Parameters

| Parameter   | Default       | Description                              |
| ----------- | ------------- | ---------------------------------------- |
| `Username`  | `qq_58062502` | CSDN account name (URL segment)          |
| `Count`     | `5`           | Number of latest articles to show        |
| `ReadmePath`| `README.md`   | Path to the README to update             |

## Workflow

1. Run the script (see Quick start).
2. It fetches `https://blog.csdn.net/<Username>?type=blog` with a browser user-agent-friendly request.
3. It parses article title, date, and URL from the page's `latelyList` JSON / HTML.
4. It prints the newest `Count` articles as Markdown list items.
5. It prompts `[y/N]` — confirm to replace the feed block in `ReadmePath`.
6. The block is rewritten with the format `- Mon DD - [Title](url)` (e.g. `- May 06 - [封装数字滚动动画函数](https://blog.csdn.net/...)`).

## Requirements

- The README must already contain both markers `<!-- feed start -->` and `<!-- feed end -->`. If missing, the script errors out and tells you to add them.
- PowerShell 5.1+ (no external dependencies; uses built-in `Invoke-WebRequest`).

## Notes

- CSDN sometimes rate-limits or shows an anti-bot page. If `No articles found` appears, wait a bit and retry, or open the URL in a browser to confirm the account is correct.
- The same feed block can also be auto-updated by the `blog.yml` GitHub Action (sarisia/actions-readme-feed). Use the script for an immediate manual refresh.

## See also

- [EXAMPLES.md](EXAMPLES.md) for real output and troubleshooting.
