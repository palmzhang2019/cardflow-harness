#!/usr/bin/env bash
# M2 决策输入构建脚本
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

COMPARISON_FILE="${ROUND_DIR}/07-comparison.md"
SCORE_FILE="${ROUND_DIR}/08-score.json"
PROMPT_FILE=".cardflow-harness/prompts/m2-engineering-card/04-decide-winner.md"
OUTPUT_FILE="${ROUND_DIR}/00-input-decision.md"

for f in "$COMPARISON_FILE" "$SCORE_FILE" "$PROMPT_FILE"; do
  if [ ! -f "$f" ]; then
    echo "ERROR: required file not found: $f"
    exit 1
  fi
done

mkdir -p "$ROUND_DIR"

{
  echo "# Model Input"
  echo ""
  echo "- task_id: ${TASK_ID}"
  echo "- stage: m2-engineering-card"
  echo "- round: ${ROUND}"
  echo "- task: decision"
  echo ""
  echo "---"
  echo ""
  echo "## Instruction"
  echo ""
  cat "$PROMPT_FILE"
  echo ""
  echo "---"
  echo ""
  echo "## Comparison Report"
  echo ""
  cat "$COMPARISON_FILE"
  echo ""
  echo "---"
  echo ""
  echo "## Score Results"
  echo ""
  cat "$SCORE_FILE"
} > "$OUTPUT_FILE"

echo "OK: generated $OUTPUT_FILE"
ls -lh "$OUTPUT_FILE"
