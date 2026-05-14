#!/usr/bin/env bash
set -euo pipefail

TASK_ID="${1:-}"

if [ -z "$TASK_ID" ]; then
  echo "Usage: $0 <task_id>"
  echo "Example: $0 24174-customer-latest-info-add-send-date"
  exit 1
fi

RUN_DIR=".cardflow-harness/runs/${TASK_ID}"

ROUND2_DIR="${RUN_DIR}/m1-requirement-card/round-2"
ROUND3_DIR="${RUN_DIR}/m1-requirement-card/round-3"

PROMPT_FILE=".cardflow-harness/prompts/m1-requirement-card/21-freeze-requirement-card.md"

ROUND2_SELECTED="${ROUND2_DIR}/10-selected-requirement-card.md"
CONFIRMED_UNKNOWNS="${ROUND2_DIR}/12-confirmed-unknowns.txt"
ROUND2_COMPARISON="${ROUND2_DIR}/07-comparison.md"
ROUND2_SCORE="${ROUND2_DIR}/08-score.json"
ROUND2_DECISION="${ROUND2_DIR}/09-decision.md"

OUTPUT_FILE="${ROUND3_DIR}/00-input-freeze.md"

for file in "$PROMPT_FILE" "$ROUND2_SELECTED" "$CONFIRMED_UNKNOWNS" "$ROUND2_COMPARISON" "$ROUND2_SCORE" "$ROUND2_DECISION"; do
  if [ ! -f "$file" ]; then
    echo "ERROR: required file not found: $file"
    exit 1
  fi
done

mkdir -p "$ROUND3_DIR"

cat > "$OUTPUT_FILE" <<EOF_INPUT
# Model Input

- task_id: ${TASK_ID}
- stage: m1-requirement-card
- round: round-3
- task: freeze-requirement-card

---

## Instruction

EOF_INPUT

cat "$PROMPT_FILE" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'EOF_SELECTED'

---

## Round 2 Selected Requirement Card

EOF_SELECTED

cat "$ROUND2_SELECTED" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'EOF_CONFIRMED'

---

## Confirmed Unknowns Before Freeze

EOF_CONFIRMED

cat "$CONFIRMED_UNKNOWNS" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'EOF_DECISION'

---

## Round 2 Decision

EOF_DECISION

cat "$ROUND2_DECISION" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'EOF_COMPARISON'

---

## Round 2 Comparison

EOF_COMPARISON

cat "$ROUND2_COMPARISON" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'EOF_SCORE'

---

## Round 2 Score

EOF_SCORE

cat "$ROUND2_SCORE" >> "$OUTPUT_FILE"

echo "OK: generated $OUTPUT_FILE"
ls -lh "$OUTPUT_FILE"
