#!/usr/bin/env bash
# M2 冻结输入构建脚本
set -euo pipefail

TASK_ID="${1:-}"
ROUND="${2:-round-3}"

if [ -z "$TASK_ID" ]; then
  echo "Usage: $0 <task_id> [round]"
  echo "Example: $0 24174-customer-latest-info-add-send-date round-3"
  exit 1
fi

RUN_DIR=".cardflow-harness/runs/${TASK_ID}"
ROUND_DIR="${RUN_DIR}/m2-engineering-card/${ROUND}"

SELECTED_CARD="${RUN_DIR}/m2-engineering-card/round-1/10-selected-engineering-requirement-card.md"
if [ ! -f "$SELECTED_CARD" ]; then
  SELECTED_CARD="${RUN_DIR}/m2-engineering-card/round-2/10-selected-engineering-requirement-card.md"
fi

PROMPT_FILE=".cardflow-harness/prompts/m2-engineering-card/06-freeze-engineering-card.md"
OUTPUT_FILE="${ROUND_DIR}/00-input-freeze.md"

if [ ! -f "$SELECTED_CARD" ]; then
  echo "ERROR: Selected card not found (checked round-1 then round-2)"
  exit 1
fi

if [ ! -f "$PROMPT_FILE" ]; then
  echo "ERROR: prompt file not found: $PROMPT_FILE"
  exit 1
fi

mkdir -p "$ROUND_DIR"

{
  echo "# Model Input"
  echo ""
  echo "- task_id: ${TASK_ID}"
  echo "- stage: m2-engineering-card"
  echo "- round: ${ROUND}"
  echo "- task: freeze"
  echo ""
  echo "---"
  echo ""
  echo "## Instruction"
  echo ""
  cat "$PROMPT_FILE"
  echo ""
  echo "---"
  echo ""
  echo "## Selected Engineering Requirement Card"
  echo ""
  cat "$SELECTED_CARD"
} > "$OUTPUT_FILE"

echo "OK: generated $OUTPUT_FILE"
ls -lh "$OUTPUT_FILE"
