# Project state — OpenLieroX Jekyll migration

## Goal
Migrate https://openlierox.net/ from a paid dynamic (PHP + MySQL) host to a
free static site on GitHub Pages, built with Jekyll. Replicate the original
site as closely as possible.

## Status — LIVE
- [x] Downloaded original HTML, CSS and assets into `official/`
- [x] Jekyll config (`_config.yml`), `Gemfile`, `.gitignore`
- [x] Shared layout `_layouts/default.html`
- [x] Pages: index, news, downloads, screenshots, help, faq, install, wiki, forum
- [x] RSS feed `feed.xml`
- [x] GitHub Pages deploy workflow `.github/workflows/jekyll.yml`
- [x] Pushed to GitHub; Pages enabled (`build_type: workflow`)
- [x] Actions run succeeded; site deployed

Live site: https://klirktag.github.io/openlierox-jekyll/
Repo: https://github.com/klirktag/openlierox-jekyll (default branch `main`)

## How it works
- `_layouts/default.html` is the shared shell (head, logo, menu, footer).
  Pages set `title`/`description` in front matter; the layout fills the rest.
- Asset and link URLs use the `relative_url` filter so the site works under
  any `baseurl` (custom domain or project page).
- The original CSS is kept verbatim at `official/default/main.css`; its
  internal `url(...)` references resolve next to it in `official/default/images/`.

## Build / run
```sh
bundle install
bundle exec jekyll serve   # http://localhost:4000/
bundle exec jekyll build   # output in _site/
```

## Key decisions / deviations from the original
- Original is fixed 990px wide; CSS kept as-is. Added a `viewport` meta tag
  so mobile scales instead of clipping.
- **News** was DB-backed (live site shows "Could not connect to the database").
  Rebuilt as a static page from the real release history. `feed.xml` mirrors it.
- **Wiki** and **Forum** were dynamic apps — replaced with static landing
  pages linking to surviving community resources (lxalliance.net, SourceForge).
- Removed dead Google Analytics (`document.write`, retired UA property).
- Dropped the `<?xml ?>` prolog (triggers quirks mode in old IE); kept the
  XHTML 1.0 Strict doctype.
- Download links still point to SourceForge; install-help icons point to
  `/install/`.

## Repo
- Default branch: `main` (pre-existing; deploy workflow triggers on it).
