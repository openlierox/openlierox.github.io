# OpenLieroX website (Jekyll)

A static [Jekyll](https://jekyllrb.com/) replica of the original
[openlierox.net](https://openlierox.net/) website, built so the site can be
hosted for free on **GitHub Pages** instead of a paid server.

## Local development

Requires Ruby and Bundler.

```sh
bundle install
bundle exec jekyll serve
```

Then open <http://localhost:4000/>.

## Deployment

Pushing to the `main` branch triggers the
[`.github/workflows/jekyll.yml`](.github/workflows/jekyll.yml) workflow, which
builds the site and deploys it to GitHub Pages. In the repository settings,
under **Settings → Pages**, set **Source** to **GitHub Actions**.

### Custom domain

To serve the site at `openlierox.net`, add a `CNAME` file containing the
domain at the repository root and configure DNS. Keep `baseurl: ""` in
[`_config.yml`](_config.yml). For a project page
(`<user>.github.io/<repo>/`) the deploy workflow passes the correct `baseurl`
automatically.

## Structure

| Path                        | Purpose                                            |
| --------------------------- | -------------------------------------------------- |
| `_config.yml`               | Jekyll site configuration                          |
| `_layouts/default.html`     | Shared page shell (head, logo, menu, footer)       |
| `index.html`                | Main page                                          |
| `news/`, `downloads/`, `screenshots/`, `help/`, `faq/`, `install/` | Content pages |
| `wiki/`, `forum/`           | Static landing pages for the former dynamic apps   |
| `feed.xml`                  | RSS news feed                                      |
| `official/`                 | Original CSS, images and assets from openlierox.net |

## Differences from the original site

The original site was partly dynamic (PHP + database). Those parts cannot run
on static hosting, so:

- **News** was database-backed (the live page currently shows a database
  error). It is rebuilt here as a static page summarising the real releases.
- **Wiki** and **Forum** ran dynamic software. They are replaced with static
  landing pages that link to the surviving community resources.
- Google Analytics (a retired tracking property using `document.write`) was
  removed.
- A `viewport` meta tag was added so the fixed 990px layout scales on mobile.

Download links still point to the project's files on SourceForge.
