# Examples

## Real run output

```
PS> powershell -ExecutionPolicy Bypass -File skills/fetch-csdn-blog/scripts/fetch-csdn-blog.ps1

Fetching https://blog.csdn.net/qq_58062502?type=blog ...

Latest 5 articles:
- May 06 - [封装数字滚动动画函数](https://blog.csdn.net/qq_58062502/article/details/159856167)
- May 06 - [利用自定义Ref实现防抖](https://blog.csdn.net/qq_58062502/article/details/159855660)
- Dec 15 - [CommonJS 的工作原理是什么](https://blog.csdn.net/qq_58062502/article/details/155893021)
- Dec 13 - [ESModule的工作原理是什么](https://blog.csdn.net/qq_58062502/article/details/155892650)
- Nov 02 - [多行文本擦除效果](https://blog.csdn.net/qq_58062502/article/details/153529321)

Write these 5 articles into README.md between <!-- feed start --> and <!-- feed end -->? [y/N]
y

Done. Updated feed section in README.md
```

## After update, README looks like:

```md
### 📃 Recent Blog

<img align="right" width="88" src="assets/images/astronaut.png" />

<!-- feed start -->
- May 06 - [封装数字滚动动画函数](https://blog.csdn.net/qq_58062502/article/details/159856167)
- May 06 - [利用自定义Ref实现防抖](https://blog.csdn.net/qq_58062502/article/details/159855660)
- Dec 15 - [CommonJS 的工作原理是什么](https://blog.csdn.net/qq_58062502/article/details/155893021)
- Dec 13 - [ESModule的工作原理是什么](https://blog.csdn.net/qq_58062502/article/details/155892650)
- Nov 02 - [多行文本擦除效果](https://blog.csdn.net/qq_58062502/article/details/153529321)
<!-- feed end -->
```

## Troubleshooting

### "No articles found"

- CSDN returned an anti-bot page or the account name is wrong.
- Wait 1–2 minutes and retry. If it persists, open `https://blog.csdn.net/<Username>?type=blog` in a browser to verify.

### "Feed markers not found"

- The README lacks `<!-- feed start -->` / `<!-- feed end -->`. Add them first:

```md
<!-- feed start -->
- 暂无文章
<!-- feed end -->
```

### Wrong order / missing articles

- The script always takes the newest `Count` items as they appear in the page. CSDN orders by last-update time.
- Increase `Count` if you want more, e.g. `-Count 8`.
