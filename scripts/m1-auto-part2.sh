#!/usr/bin/env bash
set -euo pipefail

TASK_ID="${1:-}"

if [ -z "$TASK_ID" ]; then
  echo "Usage: $0 <task_id>"
  echo "Example: $0 24174-customer-latest-info-add-send-date"
  exit 1
fi

CLAUDE_MODEL="${CLAUDE_MODEL:-opus}"

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
echo "M1 Auto Part 2"
echo "task_id: ${TASK_ID}"
echo "claude_model: ${CLAUDE_MODEL}"
echo "============================================================"

require_cmd claude
require_cmd python3

require_file "${M1_DIR}/round-2/10-selected-requirement-card.md"
require_file "${M1_DIR}/round-2/12-confirmed-unknowns.txt"
require_file ".cardflow-harness/prompts/m1-requirement-card/21-freeze-requirement-card.md"
require_file ".cardflow-harness/scripts/build-m1-freeze-input.sh"

mkdir -p "${M1_DIR}/round-3"

echo
echo "== Step 1: Build freeze input =="
.cardflow-harness/scripts/build-m1-freeze-input.sh "${TASK_ID}"

echo
echo "== Step 2: Generate frozen requirement card =="
claude -p --model "${CLAUDE_MODEL}" \
  < "${M1_DIR}/round-3/00-input-freeze.md" \
  > "${M1_DIR}/round-3/12-frozen-requirement-card.md"

echo
echo "== Step 3: Quality checks =="

CHECK_DIR="${M1_DIR}/round-3"
CHECK_REPORT="${CHECK_DIR}/13-freeze-check.md"

{
  echo "# Freeze Check Report"
  echo
  echo "- task_id: ${TASK_ID}"
  echo "- target: ${M1_DIR}/round-3/12-frozen-requirement-card.md"
  echo
  echo "## 1. Remaining Unknowns"
  echo
  grep -n "## 9. 仍需确认 Unknowns" -A 40 \
    "${M1_DIR}/round-3/12-frozen-requirement-card.md" || true
  echo
  echo "## 2. Confirmed Items Wrongly Remaining as Unknown"
  grep -nE "表形式レポート是否|集計レポート是否|CSV 是否|api_find_report 是否|最新.*未确认|無.*未确认|无.*未确认|順番.*未确认|調査線索|调查线索" \
    "${M1_DIR}/round-3/12-frozen-requirement-card.md" || true
  echo
  echo "## 3. Implementation Leakage Check"
  grep -nE "SQL|patch|diff|lateral|window|窗口函数|字段命名|cdr_latest|性能设计|i18n key|実装|実現方法" \
    "${M1_DIR}/round-3/12-frozen-requirement-card.md" || true
} > "${CHECK_REPORT}"

cat "${CHECK_REPORT}"

echo
echo "== Step 4: Generate M1_SUMMARY.md =="

cat > "${M1_DIR}/M1_SUMMARY.md" <<SUMMARY_EOF
# M1 Requirement Card Draw Summary

## 1. Task

task_id:

\`${TASK_ID}\`

stage:

M1 Requirement Card Draw

status:

completed

final_output:

\`${M1_DIR}/round-3/12-frozen-requirement-card.md\`

---

## 2. Input Materials

- \`${RUN_DIR}/material/01-brief-1.md\`
- \`${RUN_DIR}/material/02-code-investigation-report-1.md\`
- \`${RUN_DIR}/material/00-material-package.md\`

---

## 3. Round 1 Outputs

- \`${M1_DIR}/round-1/01-candidate-codex.md\`
- \`${M1_DIR}/round-1/02-candidate-claude.md\`
- \`${M1_DIR}/round-1/03-candidate-deepseek.md\`
- \`${M1_DIR}/round-1/07-comparison.md\`
- \`${M1_DIR}/round-1/08-score.json\`
- \`${M1_DIR}/round-1/09-decision.md\`
- \`${M1_DIR}/round-1/10-selected-requirement-card.md\`

---

## 4. Round 2 Outputs

- \`${M1_DIR}/round-2/01-candidate-codex.md\`
- \`${M1_DIR}/round-2/02-candidate-claude.md\`
- \`${M1_DIR}/round-2/03-candidate-deepseek.md\`
- \`${M1_DIR}/round-2/07-comparison.md\`
- \`${M1_DIR}/round-2/08-score.json\`
- \`${M1_DIR}/round-2/09-decision.md\`
- \`${M1_DIR}/round-2/10-selected-requirement-card.md\`
- \`${M1_DIR}/round-2/11-unknowns-to-confirm.txt\`
- \`${M1_DIR}/round-2/12-confirmed-unknowns.txt\`

---

## 5. Round 3 Outputs

- \`${M1_DIR}/round-3/00-input-freeze.md\`
- \`${M1_DIR}/round-3/12-frozen-requirement-card.md\`
- \`${M1_DIR}/round-3/13-freeze-check.md\`

---

## 6. Next Stage

Next stage:

M2 Engineering Requirement Card Draw

Recommended M2 inputs:

1. Frozen Requirement Card:
   \`${M1_DIR}/round-3/12-frozen-requirement-card.md\`

2. Code Investigation Report:
   \`${RUN_DIR}/material/02-code-investigation-report-1.md\`

3. Confirmed Unknowns:
   \`${M1_DIR}/round-2/12-confirmed-unknowns.txt\`

M2 boundary:

Engineering Requirement Card may translate frozen requirements into engineering constraints and affected areas, but should still avoid direct implementation patches unless the process explicitly enters M4 Implementation.
SUMMARY_EOF

echo
echo "============================================================"
echo "M1 Auto Part 2 completed."
echo
echo "Frozen card:"
echo "  ${M1_DIR}/round-3/12-frozen-requirement-card.md"
echo
echo "Freeze check:"
echo "  ${M1_DIR}/round-3/13-freeze-check.md"
echo
echo "Summary:"
echo "  ${M1_DIR}/M1_SUMMARY.md"
echo "============================================================"
