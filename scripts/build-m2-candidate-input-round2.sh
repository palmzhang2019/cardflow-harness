#!/usr/bin/env bash
# M2 Round 2 候选输入构建脚本
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
ROUND_DIR="${RUN_DIR}/m2-engineering-card/${ROUND}"

FROZEN_REQUIREMENT_CARD="${RUN_DIR}/m1-requirement-card/round-3/12-frozen-requirement-card.md"
CODE_INVESTIGATION_REPORT="${RUN_DIR}/material/02-code-investigation-report-1.md"
CONFIRMED_UNKNOWNS="${RUN_DIR}/m1-requirement-card/round-2/12-confirmed-unknowns.txt"
M1_SUMMARY="${RUN_DIR}/m1-requirement-card/M1_SUMMARY.md"
ROUND1_SELECTED="${RUN_DIR}/m2-engineering-card/round-1/10-selected-engineering-requirement-card.md"
ROUND1_DECISION="${RUN_DIR}/m2-engineering-card/round-1/09-decision.md"
ROUND1_SCORE="${RUN_DIR}/m2-engineering-card/round-1/08-score.json"

PROMPT_FILE=".cardflow-harness/prompts/m2-engineering-card/11-generate-candidate-round2.md"
INPUT_FILE="${ROUND_DIR}/00-input-${MODEL_NAME}.md"

for f in "$FROZEN_REQUIREMENT_CARD" "$CODE_INVESTIGATION_REPORT" "$CONFIRMED_UNKNOWNS" "$M1_SUMMARY" "$PROMPT_FILE"; do
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
  echo "- model: ${MODEL_NAME}"
  echo ""
  echo "---"
  echo ""
  echo "## Instruction"
  echo ""
  cat "$PROMPT_FILE"
  echo ""
  echo "---"
  echo ""
  echo "## 1. Frozen Requirement Card (M1 Final Output)"
  echo ""
  cat "$FROZEN_REQUIREMENT_CARD"
  echo ""
  echo "---"
  echo ""
  echo "## 2. Code Investigation Report"
  echo ""
  cat "$CODE_INVESTIGATION_REPORT"
  echo ""
  echo "---"
  echo ""
  echo "## 3. Confirmed Unknowns (M1 Round 2)"
  echo ""
  cat "$CONFIRMED_UNKNOWNS"
  echo ""
  echo "---"
  echo ""
  echo "## 4. M1 Summary"
  echo ""
  cat "$M1_SUMMARY"
} > "$INPUT_FILE"

if [ -f "$ROUND1_SELECTED" ]; then
  {
    echo ""
    echo "---"
    echo ""
    echo "## 5. Round 1 Selected Engineering Requirement Card"
    echo ""
    cat "$ROUND1_SELECTED"
  } >> "$INPUT_FILE"
fi

if [ -f "$ROUND1_DECISION" ]; then
  {
    echo ""
    echo "---"
    echo ""
    echo "## 6. Round 1 Decision"
    echo ""
    cat "$ROUND1_DECISION"
  } >> "$INPUT_FILE"
fi

if [ -f "$ROUND1_SCORE" ]; then
  {
    echo ""
    echo "---"
    echo ""
    echo "## 7. Round 1 Score"
    echo ""
    cat "$ROUND1_SCORE"
  } >> "$INPUT_FILE"
fi

echo "OK: generated $INPUT_FILE"
ls -lh "$INPUT_FILE"
