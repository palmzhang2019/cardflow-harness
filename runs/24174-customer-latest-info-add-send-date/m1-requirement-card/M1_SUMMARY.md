# M1 Requirement Card Draw Summary

task_id:
24174-customer-latest-info-add-send-date

stage:
M1 Requirement Card Draw

status:
completed

final_output:
.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/round-3/12-frozen-requirement-card.md

============================================================
1. Input Materials
============================================================

本次 M1 的输入材料：

1. 沉淀物-1
.cardflow-harness/runs/24174-customer-latest-info-add-send-date/material/01-brief-1.md

2. Code Investigation Report
.cardflow-harness/runs/24174-customer-latest-info-add-send-date/material/02-code-investigation-report-1.md

3. Unified Material Package
.cardflow-harness/runs/24174-customer-latest-info-add-send-date/material/00-material-package.md

============================================================
2. Round 1
============================================================

Round 1 candidates:

- Codex / GPT-5.4
  round-1/01-candidate-codex.md

- Claude / Opus
  round-1/02-candidate-claude.md

- DeepSeek v4 Pro
  round-1/03-candidate-deepseek.md

Round 1 outputs:

- comparison:
  round-1/07-comparison.md

- score:
  round-1/08-score.json

- decision:
  round-1/09-decision.md

- selected card:
  round-1/10-selected-requirement-card.md

Round 1 winner:
Claude

Round 1 notes:
Claude was selected because it had the strongest structure, AC quality, and risk/Unknown handling.
However, Round 1 Selected Card still had issues:
- “最新一条発着信履歴” was slightly over-confirmed.
- Some engineering/code investigation language remained.
- Permission scope had a small contradiction.

============================================================
3. Round 2
============================================================

Round 2 purpose:
修正 Round 1 Selected Card 中的需求语言问题。

Round 2 focus:
- Separate “display the field” from “latest judgement logic”.
- Do not confirm “latest call history” prematurely.
- Reduce engineering/code-language expressions.
- Fix permission Unknown / Out of Scope contradiction.
- Keep all unresolved Unknowns.

Round 2 candidates:

- Codex / GPT-5.4
  round-2/01-candidate-codex.md

- Claude / Opus
  round-2/02-candidate-claude.md

- DeepSeek v4 Pro
  round-2/03-candidate-deepseek.md

Round 2 outputs:

- comparison:
  round-2/07-comparison.md

- score:
  round-2/08-score.json

- decision:
  round-2/09-decision.md

- selected card:
  round-2/10-selected-requirement-card.md

Round 2 winner:
Codex

Round 2 notes:
Codex became the preferred base because its Requirement Card language was cleaner, less code-oriented, and better suited for freezing.

============================================================
4. Confirmed Unknowns
============================================================

Before Round 3 Freeze, the following Unknowns were manually confirmed:

U-001:
表形式レポート + 集計レポート 都要求支持「発着信日時（最新）」。

U-002:
集計レポート 必须支持「発着信日時（最新）」。

U-003:
「最新」口径沿用现有「顧客最新情報」既存链路中的“最新”定义。

U-004:
无発着信履歴数据时显示 `-`。

U-005:
「順番」最后一位 = 包含自定义项目后的全列表最后。

U-006:
CSV 属于本次范围。

U-007:
api_find_report 需要同步影响。

U-008:
表形式 CSV + 集計 CSV 都属于范围。

Confirmed unknowns file:
round-2/12-confirmed-unknowns.txt

============================================================
5. Round 3 Freeze
============================================================

Round 3 input:
round-3/00-input-freeze.md

Final frozen card:
round-3/12-frozen-requirement-card.md

Frozen Card status:
completed and checked

Final remaining Unknowns:
1. 多语言文案 / 翻译范围
2. 列宽 / 排序 / 筛选默认行为
3. 权限可见性
4. 完整菜单操作路径

Confirmed In Scope in Frozen Card:
- 表形式レポート
- 集計レポート
- CSV
- 表形式 CSV
- 集計 CSV
- api_find_report
- 无数据时显示 `-`
- 順番为包含自定义项目后的全列表最后
- 「最新」口径沿用现有「顧客最新情報」既存链路中的“最新”定义

============================================================
6. Quality Check Result
============================================================

Final grep checks passed.

Unknowns check:
Only 4 remaining Unknowns were found, all valid.

Implementation leakage check:
No implementation plan, SQL, patch, diff, field naming, or performance design was included.
The only matches were boundary statements saying those items are out of M1 scope.

============================================================
7. Next Stage
============================================================

Next stage:
M2 Engineering Requirement Card Draw

Recommended M2 inputs:
1. Frozen Requirement Card:
   round-3/12-frozen-requirement-card.md

2. Code Investigation Report:
   material/02-code-investigation-report-1.md

3. Confirmed Unknowns:
   round-2/12-confirmed-unknowns.txt

M2 boundary:
Engineering Requirement Card may translate frozen requirements into engineering constraints and affected areas, but should still avoid direct implementation patches unless the process explicitly enters M4 Implementation.

