#!/usr/bin/env bash
set -euo pipefail

TASK_ID="${1:-}"
ROUND="${2:-round-1}"

if [ -z "$TASK_ID" ]; then
  echo "Usage: $0 <task_id> [round]"
  echo "Example: $0 24174-customer-latest-info-add-send-date round-1"
  exit 1
fi

RUN_DIR=".cardflow-harness/runs/${TASK_ID}"
ROUND_DIR="${RUN_DIR}/m1-requirement-card/${ROUND}"

PROMPT_FILE=".cardflow-harness/prompts/m1-requirement-card/03-score-candidates.md"

CODEX_FILE="${ROUND_DIR}/01-candidate-codex.md"
CLAUDE_FILE="${ROUND_DIR}/02-candidate-claude.md"
DEEPSEEK_FILE="${ROUND_DIR}/03-candidate-deepseek.md"
COMPARISON_FILE="${ROUND_DIR}/07-comparison.md"

OUTPUT_FILE="${ROUND_DIR}/06-input-score.md"

for file in "$PROMPT_FILE" "$CODEX_FILE" "$CLAUDE_FILE" "$DEEPSEEK_FILE" "$COMPARISON_FILE"; do
  if [ ! -f "$file" ]; then
    echo "ERROR: required file not found: $file"
    exit 1
  fi
done

cat > "$OUTPUT_FILE" <<EOF_INPUT
# Model Input

- task_id: ${TASK_ID}
- stage: m1-requirement-card
- round: ${ROUND}
- task: score-candidates

---

## Instruction

EOF_INPUT

cat "$PROMPT_FILE" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'EOF_COMPARISON'

---

## 07-comparison.md

EOF_COMPARISON

cat "$COMPARISON_FILE" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'EOF_CODEX'

---

## Candidate A: Codex

EOF_CODEX

cat "$CODEX_FILE" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'EOF_CLAUDE'

---

## Candidate B: Claude

EOF_CLAUDE

cat "$CLAUDE_FILE" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'EOF_DEEPSEEK'

---

## Candidate C: DeepSeek

EOF_DEEPSEEK

cat "$DEEPSEEK_FILE" >> "$OUTPUT_FILE"

echo "OK: generated $OUTPUT_FILE"
ls -lh "$OUTPUT_FILE"
