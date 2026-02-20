# Meridian Wealth Advisors — Demo Site

A controlled, fictional wealth management firm website built for consistent Web Changes module demos. Content changes happen on a predictable **12-day rotation**, giving the sales team a reliable, visible change every single day.

**Live site:** [zrenmw.github.io/meridian-wealth-demo](https://zrenmw.github.io/meridian-wealth-demo/)

> **Disclaimer:** Meridian Wealth Advisors is entirely fictional. All names, addresses, phone numbers (555-range), and email addresses (example.com) are fake. Any resemblance to real firms is coincidental.

## Design

The site uses a professional RIA (Registered Investment Adviser) aesthetic inspired by firms like Fisher Investments, Creative Planning, and Hightower Advisors:

- **Typography**: Inter (headings) + Lora (body) via Google Fonts
- **Color palette**: Navy (#1a2744), Gold (#c9a84c), Cream (#f8f6f0)
- **Layout**: Generous white space, left-aligned hero, pill-style tabs, trust badges, regulatory badges in footer
- **Interactive elements**: Tabbed services, testimonial carousel, FAQ accordion — specifically to demonstrate content that screenshot-based archiving tools miss

## Quick Start

### Prerequisites
- [Hugo](https://gohugo.io/installation/) (extended version, v0.142+)
- Git
- [gh CLI](https://cli.github.com/) (for workflow triggers)

### Local Development
```bash
# Clone the repo
git clone https://github.com/zrenmw/meridian-wealth-demo.git && cd meridian-wealth-demo

# Run the activation script (auto-detects current day in cycle)
./scripts/activate-scheduled-content.sh

# Start local dev server
hugo server -D

# Build for production
hugo --gc --minify
```

### Force a Specific Day
```bash
# Activate day 7 content (Ultra HNW fee tier + $500K minimum)
FORCE_VARIANT=7 ./scripts/activate-scheduled-content.sh
hugo server
```

### Trigger a Remote Deploy with a Specific Variant
```bash
# Deploy day 12 to the live site via GitHub Actions
gh workflow run deploy.yml -f force_variant=12
```

## Content Change Schedule

The 12-day rotation starts on the date defined in `data/schedule.yaml` and repeats. Every day produces exactly one visible, compliance-relevant change.

| Day | What Changes | Pages Affected |
|-----|-------------|----------------|
| 1 | SEC filing amendment + 2 new risk factors | Disclosures, Footer |
| 2 | Fee reduction across all tiers | Fee Schedule |
| 3 | Toll-free number + Saturday hours | Contact |
| 4 | Personnel changes (promotion + new hire) | Team, About, Home |
| 5 | DOL Fiduciary Rule compliance language | Disclosures, Footer |
| 6 | ESG Investment Analyst position posted | Careers |
| 7 | Ultra HNW tier + minimum raised to $500K | Fee Schedule, Wealth Planning |
| 8 | SEC Marketing Rule compliance + model risk | Disclosures |
| 9 | Careers reshuffled (Tax Strategist + Marketing) | Careers |
| 10 | Robert Kim departs, AUM → $2.4B | Team, About, Home |
| 11 | Client testimonials rotated | Home carousel |
| 12 | Family Office Services retainer tier added | Fee Schedule |

### Cumulative state — each row shows which version is active

| Day | disclaimers | fees | team | careers | contact | testimonials |
|-----|------------|------|------|---------|---------|-------------|
| 1 | **v2** | v1 | v1 | v1 | v1 | v1 |
| 2 | v2 | **v2** | v1 | v1 | v1 | v1 |
| 3 | v2 | v2 | v1 | v1 | **v2** | v1 |
| 4 | v2 | v2 | **v2** | v1 | v2 | v1 |
| 5 | **v3** | v2 | v2 | v1 | v2 | v1 |
| 6 | v3 | v2 | v2 | **v3** | v2 | v1 |
| 7 | v3 | **v3** | v2 | v3 | v2 | v1 |
| 8 | **v4** | v3 | v2 | v3 | v2 | v1 |
| 9 | v4 | v3 | v2 | **v2** | v2 | v1 |
| 10 | v4 | v3 | **v3** | v2 | v2 | v1 |
| 11 | v4 | v3 | v3 | v2 | v2 | **v2** |
| 12 | v4 | **v4** | v3 | v2 | v2 | v2 |

## How It Works

1. **Versioned data files** (`data/fees_v1.yaml`, `fees_v2.yaml`, etc.) contain pre-written content variants
2. **`scripts/activate-scheduled-content.sh`** calculates `(days_since_start % 12) + 1`, resets all active files to v1, then cumulatively applies every mapping up to the current day
3. **Hugo builds** the site using the active data files — shortcodes (`{{< data >}}`, `{{< office-info >}}`) pull values from YAML so content pages reflect the current variant
4. **GitHub Actions** runs this daily at 6 AM UTC (plus on push to main and manual dispatch with optional `force_variant` input)

**Important:** The activation script runs during CI/CD, so committing data file changes directly will be overridden on the next deploy. To change the live site's content variant, use `gh workflow run deploy.yml -f force_variant=N`.

## Project Structure

```
├── .github/workflows/deploy.yml     # CI/CD pipeline (GitHub Pages)
├── scripts/
│   └── activate-scheduled-content.sh # Content variant switcher
├── content/                          # Markdown pages & blog posts
├── data/                            # YAML data + versioned variants
├── layouts/
│   ├── _default/baseof.html         # Base template (fonts, Bootstrap, CSS)
│   ├── index.html                   # Home page (hero, tabs, carousel, accordion)
│   ├── partials/header.html         # Top bar + navbar
│   ├── partials/footer.html         # Footer with regulatory badges
│   ├── partials/careers-list.html   # Careers partial
│   ├── shortcodes/data.html         # Generic data lookup shortcode
│   ├── shortcodes/office-info.html  # Contact office info shortcode
│   ├── page/                        # Custom page layouts
│   └── services/                    # Service page layouts
├── static/css/style.css             # All custom styles
├── hugo.toml                        # Hugo configuration
├── CLAUDE.md                        # AI assistant context
├── CHANGELOG.md                     # Detailed change descriptions
└── README.md                        # This file
```

## Demo Prep

### Preview a Specific Day
```bash
FORCE_VARIANT=10 ./scripts/activate-scheduled-content.sh
hugo server
# Shows the site as it will appear on day 10
```

### Reset to Baseline
```bash
FORCE_VARIANT=1 ./scripts/activate-scheduled-content.sh
hugo server
```

## Adding New Content Variants

1. Create a new variant file (e.g., `data/fees_v5.yaml`)
2. Add a mapping in `scripts/activate-scheduled-content.sh` MAPPINGS array
3. Update `data/schedule.yaml` with the new day entry
4. Document the change in `CHANGELOG.md`

## Hosting

The site is deployed to **GitHub Pages** via GitHub Actions. The workflow:
- Triggers on push to `main`, daily at 6 AM UTC, or manual dispatch
- Runs the content activation script
- Builds with `hugo --minify`
- Deploys via `actions/deploy-pages@v4`

Base URL: `https://zrenmw.github.io/meridian-wealth-demo/`
