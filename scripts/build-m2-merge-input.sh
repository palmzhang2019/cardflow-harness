#!/usr/bin/env bash
# M2 合并输入构建脚本
set -euo pipefail

TASK_ID="${1:-}"
ROUND="${2:-round-1}"

if [ -z "$TASK_ID" ]; then
  echo "Usage: $0 <task_id> [round]"
  echo "Example: $0 24174-customer-latest-info-add-send-date round-1"
  exit 1
fi

RUN_DIR=".cardflow-harness/runs/${TASK_ID}"
ROUND_DIR="${RUN_DIR}/m2-engineering-card/${ROUND}"

DECISION_FILE="${ROUND_DIR}/09-decision.md"
PROMPT_FILE=".cardflow-harness/prompts/m2-engineering-card/05-merge-selected-card.md"
OUTPUT_FILE="${ROUND_DIR}/00-input-merge.md"

for f in "$DECISION_FILE" "$PROMPT_FILE"; do
  if [ ! -f "$f" ]; then
    echo "ERROR: required file not found: $f"
    exit 1
  fi
done

WINNER_CANDIDATE=""
if grep -q "Winner: codex" "$DECISION_FILE" 2>/dev/null; then
  WINNER_CANDIDATE="${ROUND_DIR}/01-candidate-codex.md"
elif grep -q "Winner: claude" "$DECISION_FILE" 2>/dev/null; then
  WINNER_CANDIDATE="${ROUND_DIR}/02-candidate-claude.md"
elif grep -q "Winner: deepseek" "$DECISION_FILE" 2>/dev/null; then
  WINNER_CANDIDATE="${ROUND_DIR}/03-candidate-deepseek.md"
fi

if [ -z "$WINNER_CANDIDATE" ] || [ ! -f "$WINNER_CANDIDATE" ]; then
  echo "ERROR: Could not determine winner candidate file"
  exit 1
fi

mkdir -p "$ROUND_DIR"

{
  echo "# Model Input"
  echo ""
  echo "- task_id: ${TASK_ID}"
  echo "- stage: m2-engineering-card"
  echo "- round: ${ROUND}"
  echo "- task: merge"
  echo ""
  echo "---"
  echo ""
  echo "## Instruction"
  echo ""
  cat "$PROMPT_FILE"
  echo ""
  echo "---"
  echo ""
  echo "## Decision Result"
  echo ""
  cat "$DECISION_FILE"
  echo ""
  echo "---"
  echo ""
  echo "## Winner Candidate"
  echo ""
  cat "$WINNER_CANDIDATE"
} > "$OUTPUT_FILE"

echo "OK: generated $OUTPUT_FILE"
ls -lh "$OUTPUT_FILE"
