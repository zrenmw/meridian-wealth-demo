#!/usr/bin/env bash
# activate-scheduled-content.sh
# Reads data/schedule.yaml and activates the correct content variants
# based on the current date (or FORCE_VARIANT env var).
#
# Usage:
#   ./scripts/activate-scheduled-content.sh          # Auto-detect day
#   FORCE_VARIANT=3 ./scripts/activate-scheduled-content.sh  # Force day 3

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
echo "Cycle length: $CYCLE_LENGTH days"

# Determine which day we're in
if [ -n "${FORCE_VARIANT:-}" ]; then
    DAY="$FORCE_VARIANT"
    echo "FORCE_VARIANT set: activating day $DAY"
else
    # Calculate days since rotation start
    START_EPOCH=$(date -j -f "%Y-%m-%d" "$ROTATION_START" "+%s" 2>/dev/null || date -d "$ROTATION_START" "+%s")
    NOW_EPOCH=$(date "+%s")
    DIFF_SECONDS=$((NOW_EPOCH - START_EPOCH))
    DIFF_DAYS=$((DIFF_SECONDS / 86400))

    # Handle dates before rotation start
    if [ "$DIFF_DAYS" -lt 0 ]; then
        DAY=1
    else
        DAY=$(( (DIFF_DAYS % CYCLE_LENGTH) + 1 ))
    fi
    echo "Current date: $(date +%Y-%m-%d)"
    echo "Days since start: $DIFF_DAYS"
    echo "Active period: Day $DAY (of $CYCLE_LENGTH)"
fi

echo ""
echo "--- Activating content for Day $DAY ---"

# Define day-to-file mappings
# Format: "day:source:target"
MAPPINGS=(
    "1:disclaimers_v2.yaml:disclaimers.yaml"
    "2:fees_v2.yaml:fees.yaml"
    "3:contact_v2.yaml:contact.yaml"
    "4:team_v2.yaml:team.yaml"
    "5:disclaimers_v3.yaml:disclaimers.yaml"
    "6:careers_v3.yaml:careers.yaml"
    "7:fees_v3.yaml:fees.yaml"
    "8:disclaimers_v4.yaml:disclaimers.yaml"
    "9:careers_v2.yaml:careers.yaml"
    "10:team_v3.yaml:team.yaml"
    "11:testimonials_v2.yaml:testimonials.yaml"
    "12:fees_v4.yaml:fees.yaml"
)

# Start with base versions (v1)
echo "Resetting to base versions..."
for base in fees_v1.yaml team_v1.yaml disclaimers_v1.yaml careers_v1.yaml contact_v1.yaml testimonials_v1.yaml; do
    target="${base/_v1/}"
    if [ -f "$DATA_DIR/$base" ]; then
        cp "$DATA_DIR/$base" "$DATA_DIR/$target"
        echo "  Reset: $target <- $base"
    fi
done

# Apply changes for all days up to and including current day
# This ensures cumulative changes work correctly
for mapping in "${MAPPINGS[@]}"; do
    IFS=':' read -r map_day source target <<< "$mapping"
    if [ "$map_day" -le "$DAY" ]; then
        if [ -f "$DATA_DIR/$source" ]; then
            cp "$DATA_DIR/$source" "$DATA_DIR/$target"
            echo "  Day $map_day: $target <- $source"
        else
            echo "  WARNING: $source not found, skipping"
        fi
    fi
done

echo ""
echo "=== Content activation complete ==="
echo "Run 'hugo' to build the site with activated content."
