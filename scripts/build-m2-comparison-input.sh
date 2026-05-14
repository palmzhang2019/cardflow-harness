#!/usr/bin/env bash
# M2 比较输入构建脚本
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

CANDIDATE_CODEX="${ROUND_DIR}/01-candidate-codex.md"
CANDIDATE_CLAUDE="${ROUND_DIR}/02-candidate-claude.md"
CANDIDATE_DEEPSEEK="${ROUND_DIR}/03-candidate-deepseek.md"
PROMPT_FILE=".cardflow-harness/prompts/m2-engineering-card/02-compare-candidates.md"
OUTPUT_FILE="${ROUND_DIR}/00-input-comparison.md"

for f in "$CANDIDATE_CODEX" "$CANDIDATE_CLAUDE" "$CANDIDATE_DEEPSEEK" "$PROMPT_FILE"; do
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
  echo "- task: comparison"
  echo ""
  echo "---"
  echo ""
  echo "## Instruction"
  echo ""
  cat "$PROMPT_FILE"
  echo ""
  echo "---"
  echo ""
  echo "## Candidate: codex"
  echo ""
  cat "$CANDIDATE_CODEX"
  echo ""
  echo "---"
  echo ""
  echo "## Candidate: claude"
  echo ""
  cat "$CANDIDATE_CLAUDE"
  echo ""
  echo "---"
  echo ""
  echo "## Candidate: deepseek"
  echo ""
  cat "$CANDIDATE_DEEPSEEK"
} > "$OUTPUT_FILE"

echo "OK: generated $OUTPUT_FILE"
ls -lh "$OUTPUT_FILE"
