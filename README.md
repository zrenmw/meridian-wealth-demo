# Meridian Wealth Advisors — Demo Site

A controlled, fictional wealth management firm website built for consistent Web Changes module demos. Content changes happen on a predictable 12-week schedule, giving the sales team reliable demo data every week.

## Quick Start

### Prerequisites
- [Hugo](https://gohugo.io/installation/) (extended version, v0.120+)
- Git

### Local Development
```bash
# Clone the repo
git clone <repo-url> && cd meridian-wealth-demo

# Run the activation script (auto-detects current week)
./scripts/activate-scheduled-content.sh

# Start local dev server
hugo server -D

# Build for production
hugo --minify
```

### Force a Specific Week
```bash
# Activate week 7 content (Ultra HNW fee tier)
FORCE_VARIANT=7 ./scripts/activate-scheduled-content.sh
hugo server
```

## Content Change Schedule

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
4. **GitHub Actions** runs this every Monday at 6 AM UTC (plus on push and manual trigger)

## Demo Prep

### Quick Content Edit
1. Edit any YAML file in `data/` or markdown file in `content/`
2. Push to `main`
3. Site rebuilds automatically in ~2 minutes

### Preview a Specific Week
```bash
FORCE_VARIANT=10 ./scripts/activate-scheduled-content.sh
hugo server
# Shows the site as it will appear in week 10
```

### Branch-Based Demo Prep
1. Create a branch: `git checkout -b demo/acme-corp`
2. Make custom edits for the demo
3. Push the branch — Netlify creates a preview URL automatically

## Project Structure

```
├── .github/workflows/deploy.yml    # CI/CD pipeline
├── scripts/
│   └── activate-scheduled-content.sh
├── content/                         # Markdown pages & blog posts
├── data/                           # YAML data + versioned variants
├── layouts/                        # Hugo templates
├── static/css/                     # Styles
├── config.toml                     # Hugo configuration
├── CHANGELOG.md                    # Detailed change descriptions
└── README.md                       # This file
```

## Adding New Content Variants

1. Create a new variant file (e.g., `data/fees_v4.yaml`)
2. Add a mapping in `scripts/activate-scheduled-content.sh` MAPPINGS array
3. Update `data/schedule.yaml` with the new week entry
4. Document the change in `CHANGELOG.md`

## Hosting

The site is configured for GitHub Pages by default. For Netlify:
1. Connect the GitHub repo to Netlify
2. Set build command: `./scripts/activate-scheduled-content.sh && hugo --minify`
3. Set publish directory: `public`
4. Branch deploy previews work automatically
