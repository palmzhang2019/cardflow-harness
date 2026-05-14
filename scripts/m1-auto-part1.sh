#!/usr/bin/env bash
set -euo pipefail

TASK_ID="${1:-}"

if [ -z "$TASK_ID" ]; then
  echo "Usage: $0 <task_id>"
  echo "Example: $0 24174-customer-latest-info-add-send-date"
  exit 1
fi

CODEX_MODEL="${CODEX_MODEL:-gpt-5.4}"
CLAUDE_MODEL="${CLAUDE_MODEL:-opus}"
DEEPSEEK_MODEL="${DEEPSEEK_MODEL:-deepseek-v4-pro}"

RUN_DIR=".cardflow-harness/runs/${TASK_ID}"
M1_DIR="${RUN_DIR}/m1-requirement-card"

require_file() {
  if [ ! -f "$1" ]; then
    echo "ERROR: required file not found: $1"
    exit 1
  fi
}

require_cmd() {
  if ! command -v "$1" >/dev/null 2>&1; then
    echo "ERROR: command not found: $1"
    exit 1
  fi
}

echo "============================================================"
echo "M1 Auto Part 1"
echo "task_id: ${TASK_ID}"
echo "codex_model: ${CODEX_MODEL}"
echo "claude_model: ${CLAUDE_MODEL}"
echo "deepseek_model: ${DEEPSEEK_MODEL}"
echo "============================================================"

require_cmd codex
require_cmd claude
require_cmd python3

if [ -z "${DEEPSEEK_API_KEY:-}" ]; then
  echo "ERROR: DEEPSEEK_API_KEY is not set"
  exit 1
fi

require_file "${RUN_DIR}/material/01-brief-1.md"
require_file "${RUN_DIR}/material/02-code-investigation-report-1.md"

mkdir -p "${M1_DIR}/round-1" "${M1_DIR}/round-2" "${M1_DIR}/round-3"

echo
echo "== Step 1: Build material package =="
.cardflow-harness/scripts/build-material-package.sh "${TASK_ID}"

echo
echo "== Step 2: Build Round 1 candidate inputs =="
.cardflow-harness/scripts/build-m1-candidate-input.sh "${TASK_ID}" round-1 codex
.cardflow-harness/scripts/build-m1-candidate-input.sh "${TASK_ID}" round-1 claude
.cardflow-harness/scripts/build-m1-candidate-input.sh "${TASK_ID}" round-1 deepseek

echo
echo "== Step 3: Generate Round 1 candidates =="
codex exec --skip-git-repo-check -m "${CODEX_MODEL}" - \
  < "${M1_DIR}/round-1/00-input-codex.md" \
  > "${M1_DIR}/round-1/01-candidate-codex.md"

claude -p --model "${CLAUDE_MODEL}" \
  < "${M1_DIR}/round-1/00-input-claude.md" \
  > "${M1_DIR}/round-1/02-candidate-claude.md"

.cardflow-harness/scripts/call-deepseek.py \
  "${M1_DIR}/round-1/00-input-deepseek.md" \
  "${M1_DIR}/round-1/03-candidate-deepseek.md" \
  "${DEEPSEEK_MODEL}"

echo
echo "== Step 4: Round 1 compare =="
.cardflow-harness/scripts/build-m1-comparison-input.sh "${TASK_ID}" round-1

claude -p --model "${CLAUDE_MODEL}" \
  < "${M1_DIR}/round-1/06-input-comparison.md" \
  > "${M1_DIR}/round-1/07-comparison.md"

echo
echo "== Step 5: Round 1 score =="
.cardflow-harness/scripts/build-m1-score-input.sh "${TASK_ID}" round-1

.cardflow-harness/scripts/call-deepseek.py \
  "${M1_DIR}/round-1/06-input-score.md" \
  "${M1_DIR}/round-1/08-score.json" \
  "${DEEPSEEK_MODEL}"

python3 -m json.tool "${M1_DIR}/round-1/08-score.json" >/dev/null

echo
echo "== Step 6: Round 1 decision =="
.cardflow-harness/scripts/build-m1-decision-input.sh "${TASK_ID}" round-1

claude -p --model "${CLAUDE_MODEL}" \
  < "${M1_DIR}/round-1/06-input-decision.md" \
  > "${M1_DIR}/round-1/09-decision.md"

echo
echo "== Step 7: Round 1 selected card =="
.cardflow-harness/scripts/build-m1-merge-input.sh "${TASK_ID}" round-1

claude -p --model "${CLAUDE_MODEL}" \
  < "${M1_DIR}/round-1/06-input-merge-selected.md" \
  > "${M1_DIR}/round-1/10-selected-requirement-card.md"

echo
echo "== Step 8: Build Round 2 candidate inputs =="
.cardflow-harness/scripts/build-m1-candidate-input-round2.sh "${TASK_ID}" round-2 codex
.cardflow-harness/scripts/build-m1-candidate-input-round2.sh "${TASK_ID}" round-2 claude
.cardflow-harness/scripts/build-m1-candidate-input-round2.sh "${TASK_ID}" round-2 deepseek

echo
echo "== Step 9: Generate Round 2 candidates =="
codex exec --skip-git-repo-check -m "${CODEX_MODEL}" - \
  < "${M1_DIR}/round-2/00-input-codex.md" \
  > "${M1_DIR}/round-2/01-candidate-codex.md"

claude -p --model "${CLAUDE_MODEL}" \
  < "${M1_DIR}/round-2/00-input-claude.md" \
  > "${M1_DIR}/round-2/02-candidate-claude.md"

.cardflow-harness/scripts/call-deepseek.py \
  "${M1_DIR}/round-2/00-input-deepseek.md" \
  "${M1_DIR}/round-2/03-candidate-deepseek.md" \
  "${DEEPSEEK_MODEL}"

echo
echo "== Step 10: Round 2 compare =="
.cardflow-harness/scripts/build-m1-comparison-input.sh "${TASK_ID}" round-2

claude -p --model "${CLAUDE_MODEL}" \
  < "${M1_DIR}/round-2/06-input-comparison.md" \
  > "${M1_DIR}/round-2/07-comparison.md"

perl -pi -e 's/# Round 1 Candidate Comparison/# Round 2 Candidate Comparison/' \
  "${M1_DIR}/round-2/07-comparison.md" || true

echo
echo "== Step 11: Round 2 score =="
.cardflow-harness/scripts/build-m1-score-input.sh "${TASK_ID}" round-2

.cardflow-harness/scripts/call-deepseek.py \
  "${M1_DIR}/round-2/06-input-score.md" \
  "${M1_DIR}/round-2/08-score.json" \
  "${DEEPSEEK_MODEL}"

python3 -m json.tool "${M1_DIR}/round-2/08-score.json" >/dev/null

echo
echo "== Step 12: Round 2 decision =="
.cardflow-harness/scripts/build-m1-decision-input.sh "${TASK_ID}" round-2

claude -p --model "${CLAUDE_MODEL}" \
  < "${M1_DIR}/round-2/06-input-decision.md" \
  > "${M1_DIR}/round-2/09-decision.md"

python3 - <<PY
from pathlib import Path

path = Path("${M1_DIR}/round-2/09-decision.md")
text = path.read_text(encoding="utf-8")

prefixes = [
    "按指令「只输出决策报告正文」，以下是 Round 2 Decision 正文：\\n\\n---\\n\\n",
    "按指令「只输出决策报告正文」，以下是 Round 2 Decision 正文：\\n\\n",
]
for prefix in prefixes:
    if text.startswith(prefix):
        text = text[len(prefix):]

text = text.replace("# Round 1 Decision", "# Round 2 Decision", 1)
path.write_text(text, encoding="utf-8")
PY

echo
echo "== Step 13: Round 2 selected card =="
.cardflow-harness/scripts/build-m1-merge-input.sh "${TASK_ID}" round-2

claude -p --model "${CLAUDE_MODEL}" \
  < "${M1_DIR}/round-2/06-input-merge-selected.md" \
  > "${M1_DIR}/round-2/10-selected-requirement-card.md"

echo
echo "== Step 14: Extract unknowns to confirm =="
UNKNOWN_FILE="${M1_DIR}/round-2/11-unknowns-to-confirm.txt"

{
  echo "# Unknowns to Confirm Before Freeze"
  echo
  echo "请基于 Round 2 Selected Requirement Card 的 Unknowns 做人工确认。"
  echo
  echo "规则：能确认的写确认结果；不能确认的继续保留 Unknown。"
  echo
  echo "Source:"
  echo "${M1_DIR}/round-2/10-selected-requirement-card.md"
  echo
  echo "============================================================"
  echo "Extracted Unknowns"
  echo "============================================================"
  echo
  awk '
    /^## 9\. / {flag=1}
    /^## 10\. / {flag=0}
    flag {print}
  ' "${M1_DIR}/round-2/10-selected-requirement-card.md"
  echo
  echo "============================================================"
  echo "Manual Confirmation Area"
  echo "============================================================"
  echo
  echo "请在这里记录确认结果，例如："
  echo "U-001: B"
  echo "U-002: A"
  echo "..."
} > "${UNKNOWN_FILE}"

echo
echo "============================================================"
echo "M1 Auto Part 1 completed."
echo
echo "Generated:"
echo "  ${M1_DIR}/round-2/10-selected-requirement-card.md"
echo "  ${UNKNOWN_FILE}"
echo
echo "Next manual step:"
echo "  Create or edit:"
echo "  ${M1_DIR}/round-2/12-confirmed-unknowns.txt"
echo
echo "Then run:"
echo "  .cardflow-harness/scripts/m1-auto-part2.sh ${TASK_ID}"
echo "============================================================"
