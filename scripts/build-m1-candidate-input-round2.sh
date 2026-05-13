#!/usr/bin/env bash
set -euo pipefail

TASK_ID="${1:-}"
ROUND="${2:-round-2}"
MODEL_NAME="${3:-}"

if [ -z "$TASK_ID" ] || [ -z "$MODEL_NAME" ]; then
  echo "Usage: $0 <task_id> <round> <model_name>"
  echo "Example: $0 24174-customer-latest-info-add-send-date round-2 codex"
  exit 1
fi

RUN_DIR=".cardflow-harness/runs/${TASK_ID}"
MATERIAL_FILE="${RUN_DIR}/material/00-material-package.md"

ROUND1_DIR="${RUN_DIR}/m1-requirement-card/round-1"
ROUND_DIR="${RUN_DIR}/m1-requirement-card/${ROUND}"

PROMPT_FILE=".cardflow-harness/prompts/m1-requirement-card/11-generate-candidate-round2.md"

ROUND1_SELECTED="${ROUND1_DIR}/10-selected-requirement-card.md"
ROUND1_COMPARISON="${ROUND1_DIR}/07-comparison.md"
ROUND1_SCORE="${ROUND1_DIR}/08-score.json"
ROUND1_DECISION="${ROUND1_DIR}/09-decision.md"

INPUT_FILE="${ROUND_DIR}/00-input-${MODEL_NAME}.md"

for file in "$MATERIAL_FILE" "$PROMPT_FILE" "$ROUND1_SELECTED" "$ROUND1_COMPARISON" "$ROUND1_SCORE" "$ROUND1_DECISION"; do
  if [ ! -f "$file" ]; then
    echo "ERROR: required file not found: $file"
    exit 1
  fi
done

mkdir -p "$ROUND_DIR"

cat > "$INPUT_FILE" <<EOF_INPUT
# Model Input

- task_id: ${TASK_ID}
- stage: m1-requirement-card
- round: ${ROUND}
- model: ${MODEL_NAME}

---

## Instruction

EOF_INPUT

cat "$PROMPT_FILE" >> "$INPUT_FILE"

cat >> "$INPUT_FILE" <<'EOF_SELECTED'

---

## Round 1 Selected Requirement Card

EOF_SELECTED

cat "$ROUND1_SELECTED" >> "$INPUT_FILE"

cat >> "$INPUT_FILE" <<'EOF_DECISION'

---

## Round 1 Decision

EOF_DECISION

cat "$ROUND1_DECISION" >> "$INPUT_FILE"

cat >> "$INPUT_FILE" <<'EOF_COMPARISON'

---

## Round 1 Comparison

EOF_COMPARISON

cat "$ROUND1_COMPARISON" >> "$INPUT_FILE"

cat >> "$INPUT_FILE" <<'EOF_SCORE'

---

## Round 1 Score

EOF_SCORE

cat "$ROUND1_SCORE" >> "$INPUT_FILE"

cat >> "$INPUT_FILE" <<'EOF_MATERIAL'

---

## Original Material Package

EOF_MATERIAL

cat "$MATERIAL_FILE" >> "$INPUT_FILE"

echo "OK: generated $INPUT_FILE"
ls -lh "$INPUT_FILE"
