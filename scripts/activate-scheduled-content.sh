#!/usr/bin/env bash
# activate-scheduled-content.sh
# Reads data/schedule.yaml and activates the correct content variants
# based on the current date (or FORCE_VARIANT env var).
#
# Usage:
#   ./scripts/activate-scheduled-content.sh          # Auto-detect week
#   FORCE_VARIANT=3 ./scripts/activate-scheduled-content.sh  # Force week 3

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
DATA_DIR="$PROJECT_DIR/data"
SCHEDULE="$DATA_DIR/schedule.yaml"

# Parse rotation_start from schedule.yaml (simple grep, no yq dependency)
ROTATION_START=$(grep 'rotation_start:' "$SCHEDULE" | head -1 | sed 's/.*"\(.*\)".*/\1/')
CYCLE_LENGTH=12

echo "=== Meridian Content Activation ==="
echo "Rotation start: $ROTATION_START"
echo "Cycle length: $CYCLE_LENGTH weeks"

# Determine which week we're in
if [ -n "${FORCE_VARIANT:-}" ]; then
    WEEK="$FORCE_VARIANT"
    echo "FORCE_VARIANT set: activating week $WEEK"
else
    # Calculate weeks since rotation start
    START_EPOCH=$(date -j -f "%Y-%m-%d" "$ROTATION_START" "+%s" 2>/dev/null || date -d "$ROTATION_START" "+%s")
    NOW_EPOCH=$(date "+%s")
    DIFF_SECONDS=$((NOW_EPOCH - START_EPOCH))
    DIFF_DAYS=$((DIFF_SECONDS / 86400))

    # Handle dates before rotation start
    if [ "$DIFF_DAYS" -lt 0 ]; then
        WEEK=1
    else
        WEEK=$(( (DIFF_DAYS % CYCLE_LENGTH) + 1 ))
    fi
    echo "Current date: $(date +%Y-%m-%d)"
    echo "Days since start: $DIFF_DAYS"
    echo "Active period: $WEEK (of $CYCLE_LENGTH)"
fi

echo ""
echo "--- Activating content for Week $WEEK ---"

# Define week-to-file mappings
# Format: "week:source:target"
MAPPINGS=(
    "1:disclaimers_v2.yaml:disclaimers.yaml"
    "2:fees_v2.yaml:fees.yaml"
    "4:team_v2.yaml:team.yaml"
    "5:disclaimers_v2.yaml:disclaimers.yaml"
    "7:fees_v3.yaml:fees.yaml"
    "9:careers_v2.yaml:careers.yaml"
    "10:disclaimers_v3.yaml:disclaimers.yaml"
    "11:team_v2.yaml:team.yaml"
    "12:fees_v3.yaml:fees.yaml"
    "12:testimonials_v2.yaml:testimonials.yaml"
)

# Start with base versions (v1)
echo "Resetting to base versions..."
for base in fees_v1.yaml team_v1.yaml disclaimers_v1.yaml careers_v1.yaml; do
    target="${base/_v1/}"
    if [ -f "$DATA_DIR/$base" ]; then
        cp "$DATA_DIR/$base" "$DATA_DIR/$target"
        echo "  Reset: $target <- $base"
    fi
done
# Reset testimonials to original
if [ -f "$DATA_DIR/testimonials.yaml" ]; then
    echo "  Kept: testimonials.yaml (base)"
fi

# Apply changes for all weeks up to and including current week
# This ensures cumulative changes work correctly
for mapping in "${MAPPINGS[@]}"; do
    IFS=':' read -r map_week source target <<< "$mapping"
    if [ "$map_week" -le "$WEEK" ]; then
        if [ -f "$DATA_DIR/$source" ]; then
            cp "$DATA_DIR/$source" "$DATA_DIR/$target"
            echo "  Week $map_week: $target <- $source"
        else
            echo "  WARNING: $source not found, skipping"
        fi
    fi
done

echo ""
echo "=== Content activation complete ==="
echo "Run 'hugo' to build the site with activated content."
