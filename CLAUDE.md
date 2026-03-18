# CLAUDE.md — Meridian Wealth Advisors Demo Site

This document describes the codebase structure, conventions, and workflows for AI assistants working on this repository.

## Project Overview

**Meridian Wealth Advisors** is a fictional wealth management firm website built as a controlled demo for web-change-archiving and monitoring tools. It uses a 12-day content rotation cycle to produce predictable, daily changes across compliance-relevant content (fees, disclosures, team roster, job postings).

- **Live site**: https://zrenmw.github.io/meridian-wealth-demo/
- **Stack**: Hugo (static site generator) + GitHub Pages + GitHub Actions
- **No backend, no database, no Node.js** — pure Hugo + YAML + Markdown

---

## Repository Structure

```
meridian-wealth-demo/
├── hugo.toml                          # Hugo site configuration
├── README.md                          # Human-readable project documentation
├── CHANGELOG.md                       # 12-day rotation change log
├── CLAUDE.md                          # This file
│
├── content/                           # Markdown content pages
│   ├── _index.md                      # Home page metadata
│   ├── about.md, careers.md, ...      # Top-level pages
│   ├── insights/                      # Blog articles (10 posts)
│   ├── services/                      # Service pages (5 pages)
│   └── disclosures/                   # Legal/compliance pages
│
├── data/                              # YAML data files (dynamic content)
│   ├── schedule.yaml                  # 12-day rotation schedule definition
│   ├── fees.yaml                      # Active fee schedule (symlinked by script)
│   ├── fees_v1.yaml … fees_v4.yaml    # Versioned fee variants
│   ├── team.yaml                      # Active team roster
│   ├── team_v1.yaml … team_v3.yaml    # Versioned team variants
│   ├── careers.yaml / _v1–_v3         # Job postings variants
│   ├── contact.yaml / _v1–_v2         # Office contact info variants
│   ├── disclaimers.yaml / _v1–_v4     # Regulatory disclaimer variants
│   └── testimonials.yaml / _v1–_v2   # Client testimonial variants
│
├── layouts/                           # Hugo Go templates
│   ├── _default/
│   │   ├── baseof.html                # Base template (fonts, Bootstrap, CSS)
│   │   ├── single.html                # Generic single-page template
│   │   └── list.html                  # List page template
│   ├── index.html                     # Home page template (~500 lines)
│   ├── partials/                      # Reusable template fragments
│   │   ├── header.html                # Top bar + navbar
│   │   ├── footer.html                # Footer + regulatory badges
│   │   ├── fee-table.html             # Fee tier table component
│   │   ├── team-grid.html             # Team member grid component
│   │   └── careers-list.html          # Job listings component
│   ├── shortcodes/
│   │   ├── data.html                  # {{< data "path.to.key" >}} shortcode
│   │   └── office-info.html           # Contact info shortcode
│   ├── page/                          # Layouts for specific pages
│   ├── services/                      # Service section layouts
│   └── insights/                      # Blog post layout
│
├── static/
│   └── css/style.css                  # Custom CSS (614 lines)
│
├── scripts/
│   └── activate-scheduled-content.sh  # Content rotation activation script
│
└── .github/
    └── workflows/
        └── deploy.yml                 # GitHub Actions CI/CD pipeline
```

---

## Tech Stack

| Layer | Technology |
|---|---|
| Static site generator | Hugo v0.142.0+ (extended) |
| CSS framework | Bootstrap 5.3.2 (CDN) |
| Fonts | Cormorant Garamond (headings), DM Sans (body) — Google Fonts |
| Hosting | GitHub Pages |
| CI/CD | GitHub Actions |
| Content format | Markdown + YAML |
| Templates | Hugo Go templates (`.html` files with `{{ }}` syntax) |
| Scripting | Bash (activation script, bash 4+ required) |

---

## Hugo Configuration (`hugo.toml`)

Key settings:
- `baseURL`: `https://zrenmw.github.io/meridian-wealth-demo/`
- `markup.goldmark.unsafe = true` — allows raw HTML in Markdown files
- `outputs` is HTML-only (no RSS or JSON feeds)
- Site params (`phone`, `email`, `address`, `secRegistration`, etc.) are accessible in templates via `.Site.Params.*`

---

## Content Rotation System

### How It Works

The site has **7 data types**, each with **2–4 versioned YAML variants** (`_v1` through `_v4`). A 12-day rotation cycle determines which variant is "active" (i.e., copied to the canonical filename like `fees.yaml`).

The schedule is defined in `data/schedule.yaml`:
```yaml
rotation_start: "2026-02-16"
cycle_length_days: 12
days:
  1:
    disclaimers: disclaimers_v2.yaml
  2:
    disclaimers: disclaimers_v2.yaml
    fees: fees_v2.yaml
  # ... cumulative through day 12
```

Each day's mapping is **cumulative** — Day N applies all changes from Days 1 through N on top of the `_v1` baseline.

### Activation Script

`scripts/activate-scheduled-content.sh`:
- Calculates which day in the 12-day cycle today falls on
- Resets all data files to `_v1` baseline via `cp`
- Applies cumulative day mappings from `schedule.yaml`
- Override: `FORCE_VARIANT=7 ./scripts/activate-scheduled-content.sh`
- Handles both macOS (`date -j`) and Linux (`date -d`) date syntax

### Active vs. Variant Files

- **Active files** (e.g., `fees.yaml`, `team.yaml`) — what Hugo builds with; managed by the activation script
- **Variant files** (e.g., `fees_v2.yaml`) — source-of-truth for each rotation state
- **Never manually edit active files** — they are overwritten on each activation

---

## Development Workflows

### Local Development

```bash
# 1. Activate today's scheduled content
./scripts/activate-scheduled-content.sh

# 2. Start Hugo development server with live reload
hugo server -D

# 3. Preview a specific rotation day (1–12)
FORCE_VARIANT=7 ./scripts/activate-scheduled-content.sh
hugo server
```

### Production Build

```bash
hugo --gc --minify
# Output goes to ./public/ (gitignored)
```

### Adding New Content Variants

1. Create a new versioned data file (e.g., `data/fees_v5.yaml`)
2. Add the mapping to `data/schedule.yaml` under the appropriate day
3. Test locally with `FORCE_VARIANT=<day>` to verify
4. Commit — the CI/CD pipeline activates content automatically on each deploy

---

## Template Conventions

### Data Access in Templates

Use `with` guards to safely access YAML data:
```html
{{ with .Site.Data.fees }}
  {{ range .tiers }}
    <td>{{ .minimum }}</td>
  {{ end }}
{{ end }}
```

Always provide fallback values:
```html
{{ with .Site.Data.team.aum }}{{ . }}{{ else }}$2.8B{{ end }}
```

### Shortcodes

The `{{< data "path.to.key" >}}` shortcode resolves dotted paths into `.Site.Data.*`:
```markdown
<!-- In content/about.md -->
Assets under management: {{< data "team.aum" >}}
```

The `{{< office-info >}}` shortcode renders the office address/phone from `contact.yaml`.

### Partials

Call partials with context:
```html
{{ partial "fee-table.html" . }}
{{ partial "team-grid.html" . }}
```

### Layout Hierarchy

Hugo resolves layouts in this priority order:
1. `layouts/page/<template>.html` (for `type: page` content)
2. `layouts/<section>/single.html`
3. `layouts/_default/single.html`
4. `layouts/_default/baseof.html` (always wraps everything)

---

## CSS Conventions

Custom styles live in `static/css/style.css`. Key CSS variables:
```css
--navy:      #0f1d35   /* Primary color — headers, nav, buttons */
--gold:      #c4a24e   /* Accent — highlights, hover states */
--cream:     #faf8f3   /* Section backgrounds */
--warm-white: #fdfcf9  /* Body background */
```

Naming patterns:
- Layout: `.section-padding`, `.page-header`, `.content-section`
- Components: `.fee-table`, `.team-card`, `.insight-card`
- State: `.nav-scrolled`, `.reveal-on-scroll`
- Buttons: `.btn-gold`, `.btn-navy`, `.btn-outline-light`

Interactive patterns:
- Hover effects use `transform: translateY(-1px)` + box-shadow transitions
- Scroll reveals use `.reveal-on-scroll` + intersection observer (in `baseof.html`)
- Navigation uses Bootstrap navbar with custom `.nav-scrolled` class applied via JS on scroll

---

## CI/CD Pipeline (`.github/workflows/deploy.yml`)

### Triggers
- **Scheduled**: Daily at 01:00 UTC (activates new day's content)
- **Push to `main`**: Rebuilds and redeploys
- **Manual dispatch**: Accepts optional `force_variant` input (integer 1–12)

### Pipeline Steps
1. Checkout code
2. Setup Hugo v0.142.0 (extended)
3. Run activation script (with `FORCE_VARIANT` if provided)
4. `hugo --minify` — builds to `./public/`
5. Upload artifact
6. Deploy to GitHub Pages

### Concurrency
- Group: `"pages"` — one deploy at a time
- `cancel-in-progress: false` — does not cancel running deployments

---

## File Naming Conventions

| Type | Convention | Example |
|---|---|---|
| Content pages | lowercase, hyphenated | `fee-schedule.md` |
| Data files (active) | lowercase, no suffix | `fees.yaml` |
| Data files (variants) | `_v<n>` suffix | `fees_v2.yaml` |
| Layout templates | lowercase, hyphenated | `fee-schedule.html` |
| Partial templates | descriptive noun | `team-grid.html` |
| CSS classes | lowercase, hyphenated | `.fee-table`, `.btn-gold` |

---

## Important Constraints

1. **Never edit `./public/`** — it is gitignored and rebuilt on every deploy.
2. **Never manually edit active data files** (`fees.yaml`, `team.yaml`, etc.) — the activation script overwrites them.
3. **Hugo extended required** — the extended build is needed for SCSS processing (even though current styles are plain CSS, the extended binary is pinned in CI).
4. **No JavaScript framework** — all interactivity is vanilla JS embedded in `baseof.html` or inline in templates. Do not introduce React, Vue, etc.
5. **No package.json / npm** — this is not a Node project. Do not add Node tooling.
6. **Markdown unsafe HTML** — `goldmark.unsafe = true` is intentional; raw HTML in `.md` files is allowed and used.
7. **Bootstrap from CDN only** — do not bundle Bootstrap locally.

---

## Key Files Quick Reference

| File | Purpose |
|---|---|
| `hugo.toml` | Site config, params, menus |
| `data/schedule.yaml` | 12-day rotation schedule |
| `scripts/activate-scheduled-content.sh` | Content activation logic |
| `layouts/_default/baseof.html` | Base HTML wrapper (fonts, Bootstrap, JS) |
| `layouts/index.html` | Home page template |
| `layouts/partials/header.html` | Navbar |
| `layouts/partials/footer.html` | Footer + compliance badges |
| `layouts/shortcodes/data.html` | Dynamic data shortcode |
| `static/css/style.css` | All custom styles |
| `.github/workflows/deploy.yml` | CI/CD pipeline |
| `CHANGELOG.md` | What changes on which day |
