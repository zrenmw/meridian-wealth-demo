# Meridian Wealth Advisors — Demo Site

A controlled, fictional wealth management firm website built for consistent Web Changes module demos. Content changes happen on a predictable 12-week schedule, giving the sales team reliable demo data every week.

**Live site:** [zrenmw.github.io/meridian-wealth-demo](https://zrenmw.github.io/meridian-wealth-demo/)

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

# Run the activation script (auto-detects current week)
./scripts/activate-scheduled-content.sh

# Start local dev server
hugo server -D

# Build for production
hugo --gc --minify
```

### Force a Specific Week
```bash
# Activate week 7 content (Ultra HNW fee tier)
FORCE_VARIANT=7 ./scripts/activate-scheduled-content.sh
hugo server
```

### Trigger a Remote Deploy with a Specific Variant
```bash
# Deploy week 12 to the live site via GitHub Actions
gh workflow run deploy.yml -f force_variant=12
```

## Content Change Schedule

The 12-week rotation starts on the date defined in `data/schedule.yaml` and repeats.

| Week | What Changes | Key Demo Point |
|------|-------------|----------------|
| 1 | Disclosures: new risk factors | Regulatory disclosure change |
| 2 | Fees: management fee reduced | Fee change notification |
| 3 | Blog: Q1 Outlook appears, Q4 Review expires | Forward-looking statements |
| 4 | Team: new VP, promotion | Personnel changes / ADV |
| 5 | Privacy policy: data retention clause | Privacy policy update |
| 6 | Wealth Planning: ESG options added | New service offering |
| 7 | Fees: Ultra HNW tier added | Fee structure change |
| 8 | Blog: Estate Tax Changes post | Tax guidance content |
| 9 | Careers: new positions, one removed | General site activity |
| 10 | Disclosures: DOL fiduciary rule | Critical regulatory update |
| 11 | Team/About: AUM updated, member removed | AUM accuracy |
| 12 | Home: testimonial rotated, minimum raised | Testimonial + fee change |

See [CHANGELOG.md](CHANGELOG.md) for detailed descriptions of each week's changes.

## How It Works

1. **Versioned data files** (`data/fees_v1.yaml`, `fees_v2.yaml`, etc.) contain pre-written content variants
2. **`scripts/activate-scheduled-content.sh`** reads the schedule and copies the correct variant into the active position
3. **Hugo builds** the site using the active data files
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
│   ├── page/                        # Custom page layouts
│   └── services/                    # Service page layouts
├── static/css/style.css             # All custom styles
├── hugo.toml                        # Hugo configuration
├── CLAUDE.md                        # AI assistant context
├── CHANGELOG.md                     # Detailed change descriptions
└── README.md                        # This file
```

## Demo Prep

### Quick Content Edit
1. Edit any YAML file in `data/` or markdown file in `content/`
2. Push to `main`
3. Site rebuilds automatically in ~30 seconds

### Preview a Specific Week
```bash
FORCE_VARIANT=10 ./scripts/activate-scheduled-content.sh
hugo server
# Shows the site as it will appear in week 10
```

### Reset to Baseline
```bash
FORCE_VARIANT=1 ./scripts/activate-scheduled-content.sh
hugo server
```

## Adding New Content Variants

1. Create a new variant file (e.g., `data/fees_v4.yaml`)
2. Add a mapping in `scripts/activate-scheduled-content.sh` MAPPINGS array
3. Update `data/schedule.yaml` with the new week entry
4. Document the change in `CHANGELOG.md`

## Hosting

The site is deployed to **GitHub Pages** via GitHub Actions. The workflow:
- Triggers on push to `main`, daily at 6 AM UTC, or manual dispatch
- Runs the content activation script
- Builds with `hugo --minify`
- Deploys via `actions/deploy-pages@v4`

Base URL: `https://zrenmw.github.io/meridian-wealth-demo/`
