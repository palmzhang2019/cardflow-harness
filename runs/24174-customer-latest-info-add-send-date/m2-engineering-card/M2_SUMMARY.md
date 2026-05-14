# CardFlow Harness M2 Engineering Requirement Card Draw 执行摘要

- **task_id:** `24174-customer-latest-info-add-send-date`
- **当前阶段:** M2 Engineering Requirement Card Draw **已完成**
- **最终产物:** [`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-3/12-frozen-engineering-requirement-card.md`](.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-3/12-frozen-engineering-requirement-card.md)
- **本摘要文件:** [`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/M2_SUMMARY.md`](.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/M2_SUMMARY.md)
- **下一阶段:** M3 Code-grounded Plan Draw

---

## 1. M2 的定位

M2 是 **Engineering Requirement Card**，不是 Plan，也不是 Implementation。

### M2 负责

- 把 M1 Frozen Requirement Card 翻译成工程约束
- 结合 Code Investigation Report 提取代码事实
- 明确工程影响范围
- 明确受影响输出
- 明确工程 Unknowns
- 为 M3 Code-grounded Plan 提供稳定输入

### M2 不做

- 不写代码
- 不写 SQL
- 不写 patch / diff
- 不给具体实现方案
- 不把可能相关文件写成必须修改文件
- 不进入 M3 Plan
- 不改写 M1 已冻结业务需求

---

## 2. M2 输入材料

M2 使用以下输入：

| # | 材料 | 路径 |
|---|------|------|
| 1 | M1 Frozen Requirement Card | [`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/round-3/12-frozen-requirement-card.md`](.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/round-3/12-frozen-requirement-card.md) |
| 2 | Code Investigation Report | [`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/material/02-code-investigation-report-1.md`](.cardflow-harness/runs/24174-customer-latest-info-add-send-date/material/02-code-investigation-report-1.md) |
| 3 | Confirmed Unknowns | [`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/round-2/12-confirmed-unknowns.txt`](.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/round-2/12-confirmed-unknowns.txt) |
| 4 | M1 Summary | [`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/M1_SUMMARY.md`](.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/M1_SUMMARY.md) |

---

## 3. M2 输出结构

M2 Engineering Requirement Card 固定 12 章：

| # | 章节 |
|---|------|
| 1 | Source Inputs |
| 2 | Requirement Summary |
| 3 | Confirmed Business Requirements |
| 4 | Engineering Scope |
| 5 | Affected Outputs |
| 6 | Code Investigation Facts |
| 7 | Engineering Constraints |
| 8 | Out of Scope |
| 9 | Engineering Unknowns |
| 10 | Acceptance Mapping |
| 11 | Risks / Cautions |
| 12 | Handoff to M3 Code-grounded Plan |

---

## 4. M2 脚本与 Prompt

### M2 prompt 目录

[`.cardflow-harness/prompts/m2-engineering-card/`](.cardflow-harness/prompts/m2-engineering-card/)

使用的 prompt：

- [`01-generate-candidate.md`](.cardflow-harness/prompts/m2-engineering-card/01-generate-candidate.md)
- [`02-compare-candidates.md`](.cardflow-harness/prompts/m2-engineering-card/02-compare-candidates.md)
- [`03-score-candidates.md`](.cardflow-harness/prompts/m2-engineering-card/03-score-candidates.md)
- [`04-decide-winner.md`](.cardflow-harness/prompts/m2-engineering-card/04-decide-winner.md)
- [`05-merge-selected-card.md`](.cardflow-harness/prompts/m2-engineering-card/05-merge-selected-card.md)
- [`06-freeze-engineering-card.md`](.cardflow-harness/prompts/m2-engineering-card/06-freeze-engineering-card.md)
- [`11-generate-candidate-round2.md`](.cardflow-harness/prompts/m2-engineering-card/11-generate-candidate-round2.md)

### M2 build scripts

脚本目录：[`.cardflow-harness/scripts/`](.cardflow-harness/scripts/)

- [`build-m2-candidate-input.sh`](.cardflow-harness/scripts/build-m2-candidate-input.sh)
- [`build-m2-candidate-input-round2.sh`](.cardflow-harness/scripts/build-m2-candidate-input-round2.sh)
- [`build-m2-comparison-input.sh`](.cardflow-harness/scripts/build-m2-comparison-input.sh)
- [`build-m2-score-input.sh`](.cardflow-harness/scripts/build-m2-score-input.sh)
- [`build-m2-decision-input.sh`](.cardflow-harness/scripts/build-m2-decision-input.sh)
- [`build-m2-merge-input.sh`](.cardflow-harness/scripts/build-m2-merge-input.sh)
- [`build-m2-freeze-input.sh`](.cardflow-harness/scripts/build-m2-freeze-input.sh)

---

## 5. 脚本问题与修复记录

初始脚本由 MiniMax m2.7 生成。

### 发现的问题

生成的模型输入文件中错误包含 shell 拼接代码，例如：

```bash
EOF
cat "$FROZEN_REQUIREMENT_CARD" >> "$INPUT_FILE"
cat >> "$INPUT_FILE" <<'EOF_MARKER'
```

### 只读调查

DeepSeek 做了只读调查，确认：**7 个 M2 build 脚本全部存在 heredoc 定界符不匹配问题**。

### 根因

以 `<<'EOF_MARKER'` 开启 heredoc，却用 `EOF` 关闭。

### 影响

- `round-1/00-input-codex.md`
- `round-1/00-input-claude.md`
- `round-1/00-input-deepseek.md`

曾被 shell 代码污染，不能作为模型输入。

### 修复方式

7 个 build 脚本全部改为安全拼接风格：

```bash
{
  echo "..."
  cat "$SOME_INPUT_FILE"
} > "$OUTPUT_FILE"
```

### 修复后检查

`grep` 检查无 shell 代码残留。

### 输入文件命名修复

| 旧命名 | 新命名 |
|--------|--------|
| `06-input-comparison.md` | `00-input-comparison.md` |
| `06-input-score.md` | `00-input-score.md` |
| `06-input-decision.md` | `00-input-decision.md` |
| `06-input-merge-selected.md` | `00-input-merge.md` |

---

## 6. 模型使用策略

### 三模型抽卡

- Codex / GPT-5.4
- Claude
- DeepSeek / deepseek-v4-pro

### 已确认后续规则

以后 Claude 做 candidate generation 候选生成时，默认使用 sonnet。

### 本次 M2

| 阶段 | 模型 |
|------|------|
| Round 1 Claude candidate | opus |
| Round 2 Claude candidate | sonnet |
| comparison / score / decision / merge / freeze | 主要使用 Claude opus |
| merge / freeze 阶段 | 使用 **no tools** 前缀，避免 Claude 尝试 Write tool |

### no tools 前缀

```
You must not use any tools.
Do not request file write permission.
Do not call Write.
Only output the final markdown body to stdout.
```

---

## 7. Round 1 摘要

### Round 1 候选

- `round-1/01-candidate-codex.md`
- `round-1/02-candidate-claude.md`
- `round-1/03-candidate-deepseek.md`

### Round 1 comparison

- `round-1/07-comparison.md`

### Round 1 score

- `round-1/08-score.json`

### 评分

| 模型 | 评分 |
|------|------|
| Claude | 5.00 |
| Codex | 4.35 |
| DeepSeek | 3.25 |

### Round 1 decision

- `round-1/09-decision.md`

**Winner:** Claude

### Round 1 selected

- `round-1/10-selected-engineering-requirement-card.md`

### 注意

- 第一次生成 selected 时 Claude 触发 Write tool permission，文件只有 714B。
- 后来用 **no tools** 前缀重新生成成功，文件约 21K。
- 还修正了 `M1-summary.md` → `M1_SUMMARY.md` 的路径错误。

---

## 8. Round 2 摘要

### Round 2 输入

- `round-2/00-input-codex.md`
- `round-2/00-input-claude.md`
- `round-2/00-input-deepseek.md`

### Round 2 候选

- `round-2/01-candidate-codex.md`
- `round-2/02-candidate-claude.md`
- `round-2/03-candidate-deepseek.md`

### Round 2 comparison

- `round-2/07-comparison.md`

### Round 2 score

- `round-2/08-score.json`

### 评分

| 模型 | 评分 |
|------|------|
| Claude | 5.0 |
| Codex | 4.9 |
| DeepSeek | 3.4 |

### Round 2 decision

- `round-2/09-decision.md`

**Winner:** Claude

### Round 2 selected

- `round-2/10-selected-engineering-requirement-card.md`

### Round 2 decision 建议

merge 时吸收 Codex 的两个增强点：

1. 增加 AO-09，将 `/admin/cdr/index` 显式列为 Reference Only / 参考面
2. 保留 CIF-16，说明 `admin_edit.thtml` / `admin_view.thtml` 与 add 页的一致性事实依据

### Round 2 selected 检查通过

- AO-09 已保留
- `/admin/cdr/index` 被标为 Reference Only / 参考面
- CIF-16 已保留
- `admin_edit.thtml` / `admin_view.thtml` 已保留
- 越界检查通过

---

## 9. Round 3 Freeze 摘要

### Freeze 输入

- `round-3/00-input-freeze.md`

### 最终冻结产物

- `round-3/12-frozen-engineering-requirement-card.md`

### 第一次 Freeze 问题

AO-09 和 CIF-16 被弱化 / 丢失。

### 重新 Freeze 强制要求

1. preserve AO-09
2. AO-09 must explicitly mark `/admin/cdr/index` as Reference Only / 参考面
3. preserve CIF-16
4. CIF-16 must mention `admin_edit.thtml` and `admin_view.thtml`
5. Do not remove edit/view visibility consistency evidence
6. Do not weaken the boundary that `/admin/cdr/index` is not an active modification target

### 最终 Freeze 检查通过

- AO-09 已保留
- `/admin/cdr/index` 是 Reference Only / 参考面
- OOS-05 明确 `/admin/cdr/index` 不是主动修改对象
- CIF-16 已保留
- `admin_edit.thtml` / `admin_view.thtml` 已保留
- Handoff 中明确 AO-09 不属于 5 条输出链路
- 最终越界检查通过

---

## 10. 最终 Frozen Card 核心内容

### 需求摘要

在 `admin/customer_contact_history_reports/add` 当 `target=顧客最新情報` 时，于「項目（*必須）」中追加 `発着信日時（最新）`。

### 需要覆盖 5 条输出链路

1. 表形式レポート
2. 集計レポート
3. 表形式 CSV
4. 集計 CSV
5. `api_find_report`

### 取值口径

沿用既存「顧客最新情報」链路的"最新"口径。

### 无数据时

显示 `"-"`。

### 受影响输出

| AO | 描述 |
|----|------|
| AO-01 | 表形式レポート 配置页 add |
| AO-02 | 表形式レポート 配置页 edit / view |
| AO-03 | 表形式レポート 报表查看画面 |
| AO-04 | 集計レポート 配置侧 |
| AO-05 | 集計レポート 报表查看画面 |
| AO-06 | 表形式 CSV |
| AO-07 | 集計 CSV |
| AO-08 | `api_find_report` |
| AO-09 | `/admin/cdr/index` Reference Only / 参考面 |

### AO-09 注意

AO-09 **不属于**本次 5 条输出链路，不得升格为主动修改对象。

---

## 11. 重要代码事实

最终 Frozen Card 保留的重要代码事实：

- `target=2` 的系统字段列表没有 `Cdr.start_date`
- `target=1` 才有相关 `Cdr.start_date`
- `target=2` 的"最新信息"链路通过 `customer_notes.max(id)` 关联最新 note，再 left join 到 cdr
- `/admin/cdr/index` 的「発着信時間」对应 `cdr.start_date`
- 集計 `target=2` 当前没有 cdr join
- CSV 有表形式 / 集計两类
- CSV 标题取字段 name
- `api_find_report` 基于已配置字段输出 CSV
- `edit` / `view` 与 `add` 共享字段定义来源，构成 CBR-12 的代码事实依据

---

## 12. 重要 Unknowns

### 业务侧 Unknown

| U | 描述 |
|---|------|
| U-B-01 | 多语言文案 / 翻译范围 |
| U-B-02 | 列宽 / 排序 / 筛选默认行为 |
| U-B-03 | 权限可见性 |
| U-B-04 | 完整菜单操作路径 |

### 工程层 Unknown

| U | 描述 |
|---|------|
| U-E-01 | 集計レポート 配置侧 X/Y/V 中该字段的归属 |
| U-E-02 | 発信 / 発着信 与 日付 / 日時 的既存链路实际表现 |
| U-E-03 | `api_find_report` 对外字段名与映射策略 |
| U-E-04 | 5 条输出链路上 `"-"` 显示一致性保障策略 |

### 特别注意

**U-E-01 是 M3 前置阻塞项。**

---

## 13. M3 Handoff 注意事项

M3 需要遵守：

- 不改写 M1 / M2 已确认口径
- 不把 `/admin/cdr/index` 升格为修改对象
- 不把 Code Investigation Report 中"可能相关文件"升格为"必须修改文件"
- M3 阶段不得输出 patch / diff / 完整 SQL
- 必须围绕 5 条输出链路核对取值口径与 `"-"` 显示一致性
- 进入实现前需处理 U-E-01 ~ U-E-04
- `edit` / `view` 与 `add` 的一致性需要验证
- AO-09 只是 Reference Only / 参考面

---

## 14. 最终质量检查

### 关键增强点检查

```bash
grep -nE "AO-09|Reference Only|参考面|/admin/cdr/index|CIF-16|admin_edit|admin_view" \
  .cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-3/12-frozen-engineering-requirement-card.md
```

**结果:** AO-09 / Reference Only / CIF-16 / admin_edit / admin_view **均存在**。

### 越界检查

```bash
grep -nE "SQL|patch|diff|具体实现|実装|コード修正|must modify|必须修改|必须加入|严禁提出|完整 SQL" \
  .cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-3/12-frozen-engineering-requirement-card.md || true
```

**结果:** 命中内容均为代码事实引用、M2 边界声明、防止 M3 越界的约束。没有发现具体 SQL、patch、diff 或实现方案。

### 最终结论

**M2 Frozen Engineering Requirement Card 质量检查通过。**

---

## 15. 下一步

**M2 已完成。**

### 下一阶段

M3 Code-grounded Plan Draw

### M3 推荐输入

1. [`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-3/12-frozen-engineering-requirement-card.md`](.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-3/12-frozen-engineering-requirement-card.md)
2. [`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/material/02-code-investigation-report-1.md`](.cardflow-harness/runs/24174-customer-latest-info-add-send-date/material/02-code-investigation-report-1.md)
3. [`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/M2_SUMMARY.md`](.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/M2_SUMMARY.md)

### M3 定位

Code-grounded Plan

### M3 建议

- 先做 plan，不直接 implementation
- 不在 Plan 阶段输出 patch / diff / 完整 SQL
- 不把候选相关文件直接当成必须修改文件
- 重点处理 U-E-01 ~ U-E-04
- 明确 5 条输出链路的处理与验收映射
- 保留 `/admin/cdr/index` 为 Reference Only

---

**状态: `ready for M3 Code-grounded Plan Draw`**
