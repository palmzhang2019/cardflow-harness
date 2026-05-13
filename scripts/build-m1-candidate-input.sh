#!/usr/bin/env bash
set -euo pipefail

TASK_ID="${1:-}"
ROUND="${2:-round-1}"
MODEL_NAME="${3:-}"

if [ -z "$TASK_ID" ] || [ -z "$MODEL_NAME" ]; then
  echo "Usage: $0 <task_id> <round> <model_name>"
  echo "Example: $0 24174-customer-latest-info-add-send-date round-1 codex"
  exit 1
fi

RUN_DIR=".cardflow-harness/runs/${TASK_ID}"
MATERIAL_FILE="${RUN_DIR}/material/00-material-package.md"
PROMPT_FILE=".cardflow-harness/prompts/m1-requirement-card/01-generate-candidate.md"
ROUND_DIR="${RUN_DIR}/m1-requirement-card/${ROUND}"

INPUT_FILE="${ROUND_DIR}/00-input-${MODEL_NAME}.md"

if [ ! -f "$MATERIAL_FILE" ]; then
  echo "ERROR: material package not found: $MATERIAL_FILE"
  exit 1
fi

if [ ! -f "$PROMPT_FILE" ]; then
  echo "ERROR: prompt file not found: $PROMPT_FILE"
  exit 1
fi

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

cat >> "$INPUT_FILE" <<'EOF_SEPARATOR'

---

## Material Package

EOF_SEPARATOR

cat "$MATERIAL_FILE" >> "$INPUT_FILE"

echo "OK: generated $INPUT_FILE"
ls -lh "$INPUT_FILE"
