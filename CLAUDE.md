# Project state — OpenLieroX Jekyll migration

## Goal
Migrate https://openlierox.net/ from a paid dynamic (PHP + MySQL) host to a
free static site on GitHub Pages, built with Jekyll. Replicate the original
site as closely as possible.

## Status — LIVE
- [x] Downloaded original HTML, CSS and assets into `official/`
- [x] Jekyll config (`_config.yml`), `Gemfile`, `.gitignore`
- [x] Shared layout `_layouts/default.html`
- [x] Pages: index, news, downloads, screenshots, help, faq, install, wiki,
      forum, web-demo
- [x] RSS feed `feed.xml`
- [x] GitHub Pages deploy workflow `.github/workflows/jekyll.yml`
- [x] Pushed to GitHub; Pages enabled (`build_type: workflow`)
- [x] Actions run succeeded; site deployed
- [x] All content pages converted from HTML to Markdown (kramdown + IAL),
      verified on the live site (CSS classes/ids render correctly)

Live site: https://openlierox.github.io/
Repo: https://github.com/openlierox/openlierox.github.io (default branch `main`)

## How it works
- `_layouts/default.html` is the shared shell (head, logo, menu, footer).
  Pages set `title`/`description` in front matter; the layout fills the rest.
- Content pages are **Markdown** (`*.md`, kramdown). `_config.yml` sets
  `kramdown.parse_block_html: true` so Markdown can be authored inside the
  few raw `<div>` wrappers that keep the original CSS hooks.
- CSS classes/ids are attached to Markdown blocks with kramdown IAL syntax:
  `{:.classname}` on the line after a block, `{:#id}` / `{:.class}` after an
  inline image or link. Structural wrapper `<div>`s (faq_item, release,
  screenshot_holder, the download boxes, the platform-icon grids) stay as
  raw HTML inside the `.md` files because Markdown has no equivalent.
- Asset and link URLs use the `relative_url` filter so the site works under
  any `baseurl` (custom domain or project page).
- The original CSS is kept verbatim at `official/default/main.css`; its
  internal `url(...)` references resolve next to it in `official/default/images/`.
- **Web Demo** (`web-demo/index.md`, `/web-demo/`) runs the WebAssembly
  build of OpenLieroX inline on its own page (canvas + loader copied from the
  engine's standalone `index.html`). The ~25 MB binaries ARE bundled in the repo
  at `web-demo/2026-05-06/` (`openlierox.js` / `.wasm` / `.data`); the page
  loads them via `Module.locateFile` and an async `<script>`. The build is
  multi-threaded (pthreads / SharedArrayBuffer), which needs the page to be
  cross-origin isolated (COOP + COEP). GitHub Pages can't send those headers, so
  `web-demo/coi-serviceworker.js` installs a service worker (scope
  `/web-demo/`) that adds them; it covers both the page and the engine assets.

## Build / run
```sh
bundle install
bundle exec jekyll serve   # http://localhost:4000/
bundle exec jekyll build   # output in _site/
```

No Ruby on this machine — develop with Docker instead. The repo is bind-mounted
and Jekyll watches it (`--watch --force_polling`), so content/layout edits
regenerate live (config changes still need a restart):
```sh
docker run --rm -d --name olx-jekyll -p 4001:4000 \
  --user "$(id -u):$(id -g)" \
  -e HOME=/tmp -e BUNDLE_PATH=/tmp/bundle -e BUNDLE_APP_CONFIG=/tmp/bundle \
  -v "$PWD":/site -w /site ruby:3.2 \
  sh -c "bundle install && bundle exec jekyll serve --host 0.0.0.0 --port 4000 --watch --force_polling"
# http://localhost:4001/
```
Cross-origin isolation (and thus the WASM game) only activates over HTTPS or
`localhost`, so it works at `localhost:4001` and on the live site.

## Key decisions / deviations from the original
- Original is fixed 990px wide; CSS kept as-is. Added a `viewport` meta tag
  so mobile scales instead of clipping.
- **News** was DB-backed (live site shows "Could not connect to the database").
  The 10 real posts were recovered from the Wayback Machine — the newest
  snapshot with working content (`web.archive.org`, 2024-02-10, captured
  while the page still rendered; newest post 2012-04-17). `feed.xml` mirrors it.
- **Wiki** and **Forum** were dynamic apps — replaced with static landing
  pages linking to surviving community resources (lxalliance.net, SourceForge).
  The wiki has ~2640 archived article pages on archive.org; the forum was a
  database-backed board. Recreating either is intentionally **deferred to a
  separate repo** — do not attempt it here.
- Removed dead Google Analytics (`document.write`, retired UA property).
- Dropped the `<?xml ?>` prolog (triggers quirks mode in old IE); kept the
  XHTML 1.0 Strict doctype.
- Download links still point to SourceForge; install-help icons point to
  `/install/`.
- **Web Demo** is presented as a demo: the page text states it has no network
  multiplayer and worse performance than the native build, and links to
  `/downloads/` for the full experience. The heavy WASM binaries are committed to
  the repo (~25 MB under `web-demo/2026-05-06/`) so the game is self-contained
  on GitHub Pages rather than hosted elsewhere.

## Repo
- Default branch: `main` (pre-existing; deploy workflow triggers on it).
