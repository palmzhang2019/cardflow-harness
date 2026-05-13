#!/usr/bin/env bash
set -euo pipefail

TASK_ID="${1:-}"

if [ -z "$TASK_ID" ]; then
  echo "Usage: $0 <task_id>"
  echo "Example: $0 24174-customer-latest-info-add-send-date"
  exit 1
fi

RUN_DIR=".cardflow-harness/runs/${TASK_ID}"
MATERIAL_DIR="${RUN_DIR}/material"

BRIEF_FILE="${MATERIAL_DIR}/01-brief-1.md"
REPORT_FILE="${MATERIAL_DIR}/02-code-investigation-report-1.md"
OUTPUT_FILE="${MATERIAL_DIR}/00-material-package.md"

if [ ! -f "$BRIEF_FILE" ]; then
  echo "ERROR: brief file not found: $BRIEF_FILE"
  exit 1
fi

if [ ! -f "$REPORT_FILE" ]; then
  echo "ERROR: code investigation report file not found: $REPORT_FILE"
  exit 1
fi

cat > "$OUTPUT_FILE" <<'HEADER'
# 00-material-package

## Purpose

This material package is the single source of input for M1 Requirement Card draw.

The current stage is M1 Requirement Card only.

Do not generate:
- Engineering Requirement Card
- implementation plan
- code
- SQL
- patch
- diff

The goal is to generate Requirement Card Candidates, compare them, score them, decide the best one, merge useful points, and finally produce a frozen Requirement Card.

---

## Input 1: 沉淀物-1 Task Clarification Brief

HEADER

cat "$BRIEF_FILE" >> "$OUTPUT_FILE"

cat >> "$OUTPUT_FILE" <<'MIDDLE'

---

## Input 2: 报告-1 Code Investigation Report

MIDDLE

cat "$REPORT_FILE" >> "$OUTPUT_FILE"

echo "OK: generated $OUTPUT_FILE"
ls -lh "$OUTPUT_FILE"
