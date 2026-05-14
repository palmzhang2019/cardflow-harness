# Model Input

- task_id: 24174-customer-latest-info-add-send-date
- stage: m2-engineering-card
- round: round-2
- model: deepseek

---

## Instruction

# M2 Engineering Requirement Card Candidate Generator - Round 2

你现在是 Engineering Requirement Card Candidate 生成 Agent（Round 2）。

## 任务
基于 Round 1 的反馈和输入材料，生成改进的 Engineering Requirement Card Candidate。

## 输入材料
1. Frozen Requirement Card（M1 最终产物）
2. Code Investigation Report（代码调查报告）
3. Confirmed Unknowns（M1 已确认事项）
4. M1 Summary（M1 总结）
5. Round 1 的 10-selected-engineering-requirement-card.md（Round 1 合并结果）
6. Round 1 的 09-decision.md（Round 1 决策结果）
7. Round 1 的 08-score.json（Round 1 评分结果）

## 当前阶段约束

**只允许生成 Engineering Requirement Card Candidate。**

### 禁止事项
- 不写代码
- 不写 SQL
- 不生成 patch / diff
- 不生成具体实现方案
- 不进入 M3 Code-grounded Plan
- 不把推测升格为事实
- 不把"可能相关文件"写成"必须修改文件"
- 不消除真正的 Unknowns
- 不改写 Frozen Requirement Card 中的业务需求

### 必须遵守
1. Frozen Requirement Card 为最高优先级输入，业务需求原样保留
2. Code Investigation Report 只作为代码事实来源，不作为实现指令
3. Confirmed Unknowns 中已确认的内容必须升格为 confirmed engineering requirements
4. 区分：已确认 / 来自代码调查 / 推测 / 仍需确认
5. 所有内容必须标注来源类型
6. Engineering Scope 必须清楚表达表形式、集計、CSV、api_find_report 的影响范围
7. 输出 Markdown，标题必须是：# Engineering Requirement Card Candidate
8. 必须参考 Round 1 反馈，避免重复同样的问题

## Engineering Requirement Card 固定模板（12 章节）

```markdown
# Engineering Requirement Card

## 1. Source Inputs
## 2. Requirement Summary
## 3. Confirmed Business Requirements
## 4. Engineering Scope
## 5. Affected Outputs
## 6. Code Investigation Facts
## 7. Engineering Constraints
## 8. Out of Scope
## 9. Engineering Unknowns
## 10. Acceptance Mapping
## 11. Risks / Cautions
## 12. Handoff to M3 Code-grounded Plan
```

## 参考 Round 1 评分反馈

请仔细阅读 Round 1 的评分结果，重点改进以下方面：
- requirement_alignment
- code_fact_grounding
- engineering_scope_clarity
- boundary_control
- unknowns_quality
- m3_handoff_readiness

## 输出要求
- 只输出 Engineering Requirement Card Candidate 本文
- 不要解释你将如何做
- 不要输出多余寒暄
- 严格遵循 12 章节模板
- 明确标注与 Round 1 版本的差异
---

## 1. Frozen Requirement Card (M1 Final Output)

# Frozen Requirement Card

## 1. 原始需求保真

领导原话：

```text
"【① 顧客情報レポートについて】
「顧客最新情報」においても発信日付を表示できるようしたい
※現状は「顧客対応履歴」から全履歴を確認いただき、最新の発信日付を抽出いただく必要がございます。"

ベルシステム２４
```

用户补充原话 / 线索：

```text
発着信日時（最新）→ 発着信履歴に一番最新→ cdr参照

* 表形式レポート
* 集計レポート
```

---

## 2. 一句话需求摘要

在 `admin/customer_contact_history_reports/add` 页面、当対象为「顧客最新情報」时，于 `項目（*必須）` 中追加一个可选项目 `発着信日時（最新）`，让报表（表形式レポート 与 集計レポート）以及对应 CSV 输出（表形式 CSV、集計 CSV）和 `api_find_report` 都能呈现该项目，免去现在必须从「顧客対応履歴」全履歴中人工筛选最新発信日付的步骤。该项目「最新」的判定口径已确认为：沿用现有「顧客最新情報」既存链路中的"最新"定义；具体实现方式不在本卡阶段展开。

---

## 3. 用户真实目标

- 已确认：让使用「顧客最新情報」レポート的用户，不必再回到「顧客対応履歴」逐条翻看后人工提取日期。
- 已确认：希望在当前报表使用链路中，直接看到一个名为 `発着信日時（最新）` 的结果项。
- 已确认：用户所说"最新"沿用现有「顧客最新情報」既存链路中的"最新"定义（U-003 已确认）。

---

## 4. 业务对象与操作路径

- 业务对象
  - 目标页面：`admin/customer_contact_history_reports/add`
  - 目标对象：`顧客最新情報`
  - 目标区块：`項目（*必須）`
  - 目标列：
    - `出力 項目名`
    - `表示名`
    - `順番`
  - 追加项目名：`発着信日時（最新）`
  - 参考页面：`/admin/cdr/index`
  - 参考字段：`発着信時間`
- 操作路径
  - 已确认：进入 `admin/customer_contact_history_reports/add`
  - 已确认：选择「対象」为「顧客最新情報」
  - 已确认：在 `項目（*必須）` 中确认是否可见并勾选 `発着信日時（最新）`
  - 已确认：保存后进入对应报表查看路径（表形式レポート / 集計レポート），确认该项目是否展示
  - 已确认：CSV 输出（表形式 CSV / 集計 CSV）以及 `api_find_report` 路径中确认该项目是否同步展示 / 输出
  - 未知：完整菜单进入路径

---

## 5. 当前现状

- 已确认：当前「顧客最新情報」对应的系统项目列表中，没有 `発着信日時（最新）` 这一项。
- 已确认：用户当前仍需从「顧客対応履歴」查看全履歴，再人工确认最新発信日付。
- 已确认：`/admin/cdr/index` 中存在可作为参考的 `発着信時間` 表示。
- 已确认：`項目（*必須）` 这一块对应的是表形式レポート的项目选择；集計レポート的选择形式不同。
- 推测：「顧客最新情報」既存数据链路中的"最新"口径，与"按発着信日時本身取最新"并不一定相同（来自代码调查，未经业务层独立复核；但 U-003 已由业务侧确认采用既存链路口径，二者差异不再作为本卡争点）。
- 推测：本次范围已包含集計レポート，集計レポート的数据链路与表形式不同，影响范围扩大，需在后续 Engineering Requirement Card 阶段进一步评估。
- 已确认：无発着信履歴数据时，该项目显示为 `-`（U-004 已确认）。

---

## 6. 期望结果

- 已确认：在 `admin/customer_contact_history_reports/add` 的 `項目（*必須）` 中出现 `発着信日時（最新）` 一项。
- 已确认：`発着信日時（最新）` 可被用户勾选。
- 已确认：在 `出力 項目名` 列与 `表示名` 列均显示 `発着信日時（最新）`。
- 已确认：`順番` 位于包含自定义项目后的全列表最后（U-005 已确认）。
- 已确认：勾选后，生成或查看对应 report（表形式レポート / 集計レポート）时，能够展示 `発着信日時（最新）` 这一项目。
- 已确认：CSV 输出（表形式 CSV / 集計 CSV）中能输出 `発着信日時（最新）`。
- 已确认：`api_find_report` 同步输出 `発着信日時（最新）`。
- 已确认：该项目展示的值，沿用现有「顧客最新情報」既存链路中的"最新"定义（U-003 已确认）。
- 已确认：当客户无発着信履歴数据时，该项目显示 `-`（U-004 已确认）。

---

## 7. 明确范围 In Scope

- 已确认：在 `admin/customer_contact_history_reports/add` 页面、当対象为「顧客最新情報」时，追加 `発着信日時（最新）` 这一项目。
- 已确认：该项目出现在 `項目（*必須）` 中，并具有 `出力 項目名`、`表示名`、`順番` 这些配置表现。
- 已确认：勾选该项目后，对应 report 查看画面需要能够展示该项目。
- 已确认：与该配置页配对的编辑页 / 查看页中，该项目的可见性与已保存状态应保持一致。
- 已确认：**表形式レポート** 支持 `発着信日時（最新）`（U-001 已确认）。
- 已确认：**集計レポート** 支持 `発着信日時（最新）`（U-001 / U-002 已确认）。
- 已确认：**CSV** 输出支持 `発着信日時（最新）`（U-006 已确认）。
- 已确认：**表形式 CSV** 支持 `発着信日時（最新）`（U-008 已确认）。
- 已确认：**集計 CSV** 支持 `発着信日時（最新）`（U-008 已确认）。
- 已确认：**`api_find_report`** 需要同步影响（U-007 已确认）。
- 已确认：本卡仅定义需求与验收边界，不定义实现方式。

---

## 8. 明确不做 Out of Scope

- 已确认：搜索条件调整不在本次范围内。
- 已确认：Excel / PDF 输出不在本次范围内。
- 已确认：batch / cron 不在本次范围内。
- 已确认：邮件配信内容不在本次范围内。
- 推测：`/admin/cdr/index` 自身不作为本次主动修改对象，仅作为参考页面。
- 推测：本次不主动改权限控制本身。

> 注意：多语言、列宽 / 排序 / 筛选、权限可见性等，均未在此处提前拍板，继续保留在 Unknowns。

---

## 9. 仍需确认 Unknowns

1. 多语言文案 / 翻译范围：本次是否仅日文即可，还是需要覆盖其他语言。
2. 列宽 / 排序 / 筛选默认行为：新增项目在报表查看页面与 CSV 输出中是否需要指定默认行为，还是沿用系统默认。
3. 权限可见性：是否存在特定角色下该新增项目不可见或不可选的业务要求。
4. 完整菜单操作路径未确认；虽不影响需求本身，但影响验收步骤描述。

> 以下原 Unknown 已在本卡冻结前由业务侧确认（详见 Confirmed Unknowns Before Freeze），不再列为 Unknown：
> - 表形式レポート 是否为唯一范围 → 已确认：表形式 + 集計都支持。
> - 集計レポート 是否也必须支持 → 已确认：必须支持。
> - 「最新」判定口径 → 已确认：沿用现有「顧客最新情報」既存链路中的"最新"定义。
> - 无発着信履歴数据时显示规则 → 已确认：显示 `-`。
> - 順番 "最后一位" 边界 → 已确认：包含自定义项目后的全列表最后。
> - CSV 是否属于范围 → 已确认：属于范围。
> - `api_find_report` 是否同步影响 → 已确认：需要同步影响。
> - 表形式 CSV / 集計 CSV 是否都属于范围 → 已确认：都属于范围。
> - 用户补充原话中的「* 集計レポート」是否仅为调查线索 → 已确认：是明确业务范围，不再只是调查线索。

---

## 10. 验收标准 Acceptance Criteria

- AC-001：访问 `admin/customer_contact_history_reports/add`，选择「対象」为「顧客最新情報」后，在 `項目（*必須）` 中可见 `発着信日時（最新）`。
- AC-002：`発着信日時（最新）` 在 `出力 項目名` 列与 `表示名` 列均显示为 `発着信日時（最新）`。
- AC-003：`発着信日時（最新）` 的 `順番` 出现在包含自定义项目后的全列表最后一位。
- AC-004：`発着信日時（最新）` 可被勾选并成功保存。
- AC-005（表形式レポート画面展示）：勾选 `発着信日時（最新）` 后，进入对应表形式レポート查看路径时，画面中能看到 `発着信日時（最新）` 这一列或项目。
- AC-006（集計レポート支持）：勾选 `発着信日時（最新）` 后，集計レポート 也能支持并展示 `発着信日時（最新）`。
- AC-007（最新口径）：当客户存在発着信履歴数据时，`発着信日時（最新）` 展示值与"沿用现有「顧客最新情報」既存链路中的'最新'定义"一致。
- AC-008（无数据显示）：当客户无発着信履歴数据时，`発着信日時（最新）` 显示 `-`。
- AC-009（表形式 CSV 输出）：表形式 CSV 输出中能输出 `発着信日時（最新）`，其取值口径与 AC-007 / AC-008 一致。
- AC-010（集計 CSV 输出）：集計 CSV 输出中能输出 `発着信日時（最新）`，其取值口径与 AC-007 / AC-008 一致。
- AC-011（api_find_report 同步影响）：`api_find_report` 同步输出 `発着信日時（最新）`，其取值口径与 AC-007 / AC-008 一致。
- AC-Regression-001（既存功能回归）：未勾选 `発着信日時（最新）` 时，既存 report 其他项目显示不受影响。
- AC-Regression-002（既存功能回归）：既存 `項目（*必須）` 中原有项目的显示名、順番、勾选行为不受影响。
- AC-Regression-003（既存功能回归）：既存「顧客対応履歴」侧発着信時間相关项目行为不受影响。
- AC-Regression-004（既存功能回归）：`/admin/cdr/index` 既有行为不受影响。
- AC-Regression-005（既存功能回归）：既存 表形式 CSV / 集計 CSV / `api_find_report` 中原有项目输出与字段不受影响。

> 多语言、列宽 / 排序 / 筛选、权限可见性、完整菜单操作路径等相关 AC，待 Unknowns 1、2、3、4 确认后补充；在确认前不作为必验收项。

---

## 11. 风险与歧义

- 风险 1：「最新」口径已由业务侧确认为"沿用现有「顧客最新情報」既存链路中的'最新'定义"，但该既存链路具体经过的取数路径仍需在 Engineering Requirement Card 阶段单独评估；不得由实现侧自行做出与既存链路口径不一致的解释。
- 风险 2：集計レポート 已确认纳入本次范围。集計レポート现有的数据范围与表形式不同，会触及现有数据范围之外的内容，影响面将明显扩大于仅在表形式追加一项；Engineering Requirement Card 阶段必须对集計链路单独评估。
- 风险 3："順番最后一位"已确认为包含自定义项目后的全列表最后。需注意自定义项目可在不同租户 / 配置下数量不一，验收时需明确以"当前实例下全列表最末"为准，避免被误解为某固定下标。
- 风险 4：无発着信履歴数据时显示已确认为 `-`。需在表形式画面、集計画面、表形式 CSV、集計 CSV、`api_find_report` 各输出链路保持一致，否则会出现"做一半"的不一致风险。
- 风险 5：CSV / API 派生影响范围已确认（CSV + 表形式 CSV + 集計 CSV + `api_find_report` 均纳入）。但若实现链路分散，仍存在画面与下载结果、对外接口结果不一致的"做一半"风险，必须在验收阶段逐路径核对。
- 风险 6：参考页面排序与"最新"口径不严格对齐风险。若业务把 `/admin/cdr/index` 画面看到的顺序理解为"最新"依据，需注意该参考页面的默认显示顺序更接近"按记录添加顺序倒序"，并不能直接等同于"按発着信時間取最新"；本次"最新"口径已确认沿用既存「顧客最新情報」链路，不以 `/admin/cdr/index` 视觉顺序为准。
- 风险 7：权限要求未澄清风险。若后续存在特定角色下不可见 / 不可选的业务要求，而本次提前按全员一致可见处理，容易返工。
- 歧义 1：领导原话是「発信日付」，用户补充是「発着信日時（最新）」。其中同时存在两层独立维度的表述差异：
  - 维度一（発信 / 発着信）：前者偏「発信」（去电），后者覆盖「発着信」（去电 + 来电），覆盖的通话方向不同。
  - 维度二（日付 / 日時）：前者仅到日，后者到日時，时间粒度不同。
  - 这两层表述差异在数据筛选条件上各自产生不同影响，并共同决定了对本项目数据筛选条件的不同理解，业务含义并未完全等同。本卡阶段未对该歧义最终拍板，但已确认"最新"判定沿用既存链路；具体取值粒度与方向口径需在 Engineering Requirement Card 阶段结合既存链路实现进一步澄清，不得由实现侧自行决定。
- 歧义 2：用户补充中的 `cdr参照` 目前更像线索而非已冻结业务规则，不能直接视为已确认的取数依据（"最新"口径以 U-003 确认结论为准，即既存「顧客最新情報」链路）。用户补充中的「* 集計レポート」已由 U-001 / U-002 确认为明确业务范围。

---

## 12. 给后续 Engineering Requirement Card 的输入提醒

- 代码调查只能作为需求澄清依据，不能直接跳成实现指令。Engineering Requirement Card 应基于本卡确认范围与仍未收敛的 Unknowns 再行决定实际修改面。
- 本卡已确认范围：表形式レポート + 集計レポート + 表形式 CSV + 集計 CSV + `api_find_report`。Engineering Requirement Card 阶段必须对集計链路与 `api_find_report` 链路单独评估，不得默认沿用表形式实现方式。
- 本卡已确认口径：
  - 「最新」：沿用现有「顧客最新情報」既存链路中的"最新"定义。
  - 无数据显示：`-`。
  - 順番：包含自定义项目后的全列表最后。
- 仍需在进入实现前收敛的 Unknowns：多语言、列宽 / 排序 / 筛选默认行为、权限可见性、完整菜单操作路径。
- 「展示一个名为発着信日時（最新）的项目」与「该项目背后的最新判定口径」是两件事。本卡已确认采用既存「顧客最新情報」链路口径，但 Engineering Requirement Card 阶段仍需分别处理"项目展示如何接入既存链路"与"既存链路的最新取值具体如何落到这一新项目"。
- 必须明确领导原话中的「発信日付」与用户补充中的「発着信日時（最新）」在通话方向（発信 / 発着信）与时间粒度（日付 / 日時）两个维度上的最终结论，不得由实现侧自行解释；本卡阶段未对该歧义拍板。
- 不得把代码调查报告中的"可能相关文件"升级为"必须修改文件"。
- 不得把代码调查中发现的既存数据链路差异，直接升级成与本卡已确认口径不一致的实现指令。
- 已确认范围（集計、CSV、表形式 CSV、集計 CSV、api_find_report）下的具体实现细节（SQL、字段命名、性能设计、i18n 实现细节、patch、diff）均不在本卡阶段定义，留待 Engineering Requirement Card / Plan 阶段。
- 仍未收敛的 Unknown（多语言、列宽 / 排序 / 筛选、权限可见性、完整菜单路径）一经确认，需补充对应 AC，不在本卡阶段提前拍板。

---

## 2. Code Investigation Report

# 报告-1: Code Investigation Report

## 1. 调查结论摘要
- `admin/customer_contact_history_reports/add` 的「項目（*必須）」由 controller 内系统字段数组 + 自定义字段数组生成；页面本身不硬编码具体业务字段。参考 [customer_contact_history_reports_controller.php#L112](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L112), [admin_add.thtml#L81](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml#L81)。
- 当前 `target=2（顧客最新情報）` 的系统字段列表里没有 `Cdr.start_date`；`target=1（顧客対応履歴）` 才有。参考 [customer_contact_history_reports_controller.php#L198](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L198), [customer_contact_history_reports_controller.php#L128](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L128)。
- 报表输出字段来自 `CustomerContactHistoryReportField`（保存的勾选字段），并在列表展示/API/CSV下载时按 `field_name` 映射取值。参考 [customer_contact_history_reports_controller.php#L314](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L314), [customer_contact_history_reports_controller.php#L617](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L617), [customer_contact_history_reports_controller.php#L1656](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1656)。
- `target=2` 的“最新信息”当前是通过“每个客户取 `customer_notes` 最大 `id`”来关联最新 note，再 left join 到 cdr，并非按 `Cdr.start_date` 取最新。参考 [customer_contact_history_reports_controller.php#L704](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L704)。
- `/admin/cdr/index` 的「発着信時間」就是 `cdr.start_date` 字段。参考 [cdr_controller.php#L690](/Users/palm/bluebean/callcenter/app/controllers/cdr_controller.php#L690), [ApplicationResources.properties#L1445](/Users/palm/bluebean/callcenter/app/locale/ja/ApplicationResources.properties#L1445)。
- 业务口径“最新発着信日時”通常期望按 `Cdr.start_date DESC`，但现有“顧客最新情報”链路口径是“最新 note(id)”。两者可能不一致。
- 新增项是否只要求“表形式レポート（type=1）”可选，还是“集計レポート（type=2）”也要可选。

## 2. 相关文件清单
- 入口与核心逻辑  
[customer_contact_history_reports_controller.php](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php)  
[customer_contact_history_report.php](/Users/palm/bluebean/callcenter/app/models/customer_contact_history_report.php)  
[customer_contact_history_report_field.php](/Users/palm/bluebean/callcenter/app/models/customer_contact_history_report_field.php)
- 新建/编辑/查看页面  
[admin_add.thtml](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml)  
[admin_edit.thtml](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_edit.thtml)  
[admin_view.thtml](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_view.thtml)
- 报表输出页面与JS  
[admin_report_detail_view.thtml](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_report_detail_view.thtml)  
[admin_report_detail_view_matrix.thtml](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_report_detail_view_matrix.thtml)  
[add.js](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/customer_contact_history_reports/add.js)  
[edit.js](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/customer_contact_history_reports/edit.js)  
[report_detail_view.js](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/customer_contact_history_reports/report_detail_view.js)
- CDR 参考页  
[cdr_controller.php](/Users/palm/bluebean/callcenter/app/controllers/cdr_controller.php)  
[admin_index.thtml](/Users/palm/bluebean/callcenter/app/views/cdr/admin_index.thtml)  
[index.js](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/cdr/index.js)  
[search_for_cdr_list.js](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/cdr/search_for_cdr_list.js)
- 文案与权限  
[ApplicationResources.properties(ja)](/Users/palm/bluebean/callcenter/app/locale/ja/ApplicationResources.properties)  
[CustomerContactHistoryReports.properties](/Users/palm/bluebean/callcenter/app/locale/ja/tooltip/CustomerContactHistoryReports.properties)  
[privilege.conf](/Users/palm/bluebean/callcenter/app/config/privilege.conf)

## 3. 调用链
- 配置页字段生成链  
`admin_add/admin_edit` → `__setFormData()` 组装 `tableSystemFields/matrixSystemFields` → view 渲染「項目（*必須）」。
- 字段保存链  
提交表单 `data[fields...]` + `fields_cheched_index` → `__addReport/__editReport` → `customer_contact_history_report_fields`。
- 报表输出链（表形式）  
`admin_report_detail_view`（页面）→ `admin_report_detail_list_view_get`（DataTables JSON）→ `__downloadReportDetail`（CSV）。
- 报表输出链（集計）  
`admin_report_detail_view` matrix 分支 → `admin_report_detail_view_matrix` → `__downloadMatrixTable`（CSV）。
- CDR参考链  
`/admin/cdr/index` → `admin_index_get` 读 `cdr` 表 `start_date`。

## 4. admin/customer_contact_history_reports/add 中 項目（*必須） 的生成逻辑
- 字段源头在 `__setFormData()` 内按 `target` 分支构建。`target=1` 包含 `Cdr.start_date`，`target=2` 不包含。见 [customer_contact_history_reports_controller.php#L124](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L124), [customer_contact_history_reports_controller.php#L198](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L198)。
- 页面“出力/項目名/表示名/順番”四列由 `tableSystemFields` 循环渲染。见 [admin_add.thtml#L87](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml#L87)。
- 顺番默认值来自 `$num` 递增，显示顺序即数组顺序；“放最后”依赖字段被追加在数组尾部。见 [admin_add.thtml#L105](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml#L105)。
- `campaign/target` 变化会自动提交并重建字段列表。见 [add.js#L3](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/customer_contact_history_reports/add.js#L3)。

## 5. report 输出时项目映射逻辑
- 勾选字段保存后，输出时取 `CustomerContactHistoryReportField.field_name` 做映射。见 [customer_contact_history_reports_controller.php#L617](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L617), [customer_contact_history_reports_controller.php#L1656](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1656)。
- 表形式 target=2 查询使用 `customer_contacts` + “每客户最新 note(max id)” + `cdr`。见 [customer_contact_history_reports_controller.php#L700](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L700)。
- 前端列表列名来自保存字段名，数据键为 `model_field`。见 [admin_report_detail_view.thtml#L170](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_report_detail_view.thtml#L170), [report_detail_view.js#L64](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/customer_contact_history_reports/report_detail_view.js#L64)。
- CSV标题取字段 `name`（显示名），不是 `field_name`。见 [customer_contact_history_reports_controller.php#L1612](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1612)。
- 无值时多数分支输出空字符串；部分枚举输出 `N/A` 或 `global.blank`。见 [customer_contact_history_reports_controller.php#L1666](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1666), [customer_contact_history_reports_controller.php#L1736](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1736), [ApplicationResources.properties#L288](/Users/palm/bluebean/callcenter/app/locale/ja/ApplicationResources.properties#L288)。

## 6. /admin/cdr/index 中 発着信時間 的来源与排序逻辑
- 字段来源：`cdr.start_date`。见 [cdr_controller.php#L690](/Users/palm/bluebean/callcenter/app/controllers/cdr_controller.php#L690), [ApplicationResources.properties#L1445](/Users/palm/bluebean/callcenter/app/locale/ja/ApplicationResources.properties#L1445)。
- 页面默认排序是第1列（id）降序（前后端都写了默认）。见 [cdr_controller.php#L61](/Users/palm/bluebean/callcenter/app/controllers/cdr_controller.php#L61), [index.js#L38](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/cdr/index.js#L38)。
- 配置 `CDR_SORT=0` 时强制允许第1列排序，当前环境配置文件也为 0。见 [cdr_controller.php#L77](/Users/palm/bluebean/callcenter/app/controllers/cdr_controller.php#L77), [sctel.conf#L325](/Users/palm/bluebean/callcenter/app/config/sctel.conf#L325)。
- 在大多数数据下 `id DESC` 与“最新発着信時間”接近，但不等于严格按 `start_date DESC`。

## 7. 表形式レポート / 集計レポート 影响判断
- `項目（*必須）` 仅在表形式（type=1）显示；集計使用 X/Y/V 下拉。见 [admin_add.thtml#L81](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml#L81), [admin_add.thtml#L159](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml#L159)。
- 如果只补到 `tableSystemFields`，直接影响表形式；不自动影响集計下拉。
- target=2 的集計 SQL 当前没有 join `cdr`，若将 CDR 字段引入集計口径会产生额外影响面。见 [customer_contact_history_reports_controller.php#L823](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L823)。
- 需求是否要求集計也支持“発着信日時（最新）”。

## 8. 派生输出影响判断：CSV / Excel / PDF / batch / cron / 邮件 / API
- CSV  
有两类 CSV：表形式 `__downloadReportDetail`、集計 `__downloadMatrixTable`，字段新增会影响对应CSV列。见 [customer_contact_history_reports_controller.php#L1580](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1580), [customer_contact_history_reports_controller.php#L1486](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1486)。
- Excel/PDF  
在该 controller 未发现 Excel/PDF 输出实现。
- batch/cron  
未发现与 `CustomerContactHistoryReport` 直接关联的 shell/cron 调用链。
- 邮件  
未发现该报表输出直连邮件配信。
- API  
存在 `api_find_report`/`api_update_contact`；`api_find_report` 也是基于已配置字段输出CSV。见 [customer_contact_history_reports_controller.php#L1791](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1791)。
- 补充  
`privilege.conf` 有 `admin_report_detail_download` 权限项，但 controller 未实现同名 action。见 [privilege.conf#L121](/Users/palm/bluebean/callcenter/app/config/privilege.conf#L121)。

## 9. 最小修改候选范围
- 字段定义源  
[customer_contact_history_reports_controller.php](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php)
- 新建/编辑页面字段表渲染  
[admin_add.thtml](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml)  
[admin_edit.thtml](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_edit.thtml)
- 报表查询与下载映射（table/matrix/API）  
[customer_contact_history_reports_controller.php](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php)
- 多语言文案  
[ApplicationResources.properties(ja)](/Users/palm/bluebean/callcenter/app/locale/ja/ApplicationResources.properties) 及其他语言包

## 10. 风险点
- “顧客最新情報”当前“最新”定义是 `customer_notes.max(id)`，不是 `cdr.start_date max`，存在业务口径偏差风险。
- target=2 集計查询未 join cdr；若需求扩到集計会引出SQL层影响。
- 无 cdr/无 note 的展示在不同路径有空串/`(空白)`/`N/A` 多种表现，需统一预期。
- 若以 `/admin/cdr/index` 的视觉“最新”作为标准，当前默认排序偏向 `id DESC`，需确认是否可接受。
- 权限里存在未实现 action 项，历史遗留配置可能造成误判范围。

## 11. 仍需人工确认的问题
- `発着信日時（最新）` 的“最新”判定口径是否明确为 `Cdr.start_date` 最大值，而不是最新 `customer_notes.id`？
- 仅要求 `target=2 + type=1`，还是 `type=2`（集計）也要可选/可统计？
- 无発着信履歴时目标显示是否统一为空字符串、`（空白）` 还是 `-`？
- 顺番“最后一位”是指仅系统字段最后，还是包含自定义 `CustomerContactExt.field*` 后的全列表最后？
- 需要同步到 `api_find_report` 的对外行为吗（尤其 report 为 target=2 时）？
---

## 3. Confirmed Unknowns (M1 Round 2)

# Confirmed Unknowns Before Freeze

本文件记录用户在 Round 2 Selected Requirement Card 之后，对 Unknowns 的人工确认结果。

确认时间：2026-05-14
阶段：M1 Requirement Card / before Round 3 Freeze

============================================================
A. 已确认事项
============================================================

U-001：本次是否只要求「表形式レポート」支持「発着信日時（最新）」

确认结果：B

结论：
表形式レポート + 集計レポート 都要求支持「発着信日時（最新）」。

影响：
- 集計レポート 不再是 Unknown。
- 集計レポート 应进入 In Scope。
- 后续 Acceptance Criteria 需要补充集計レポート相关验收项。

------------------------------------------------------------

U-002：「集計レポート」是否也必须支持「発着信日時（最新）」

确认结果：A

结论：
集計レポート 必须支持「発着信日時（最新）」。

影响：
- 集計レポート 明确属于本次范围。
- 后续 Engineering Requirement Card 需要基于代码调查报告继续评估集計レポート对应影响范围。
- Requirement Card 阶段仍不写实现方案。

------------------------------------------------------------

U-003：「発着信日時（最新）」中「最新」的判定口径

确认结果：B

结论：
沿用现有「顧客最新情報」既存链路中的“最新”定义。

影响：
- “最新”口径不再按「発着信時間」本身取最大值。
- 后续文档应避免写成“按発着信時間本身取最新”。
- 应写为：沿用现有「顧客最新情報」既存链路中的“最新”定义。
- 具体实现方式仍留给 Engineering Requirement Card / Plan 阶段，不在 Requirement Card 中展开。

------------------------------------------------------------

U-004：客户无発着信履歴数据时，「発着信日時（最新）」显示什么

确认结果：B

结论：
无数据时显示 `-`。

影响：
- Acceptance Criteria 需要补充空数据场景：
  客户无発着信履歴数据时，「発着信日時（最新）」显示 `-`。

------------------------------------------------------------

U-005：「順番」“最后一位”的精确语义

确认结果：B

结论：
「最后一位」指包含自定义项目后的全列表最后。

影响：
- 順番 验收标准应明确为：
  「発着信日時（最新）」出现在包含自定义项目后的全列表最后。

------------------------------------------------------------

U-006：CSV 是否属于本次范围

确认结果：A

结论：
CSV 属于本次范围。

影响：
- CSV 不再是 Unknown。
- CSV 应进入 In Scope。
- Acceptance Criteria 需要补充 CSV 输出确认。

------------------------------------------------------------

U-007：api_find_report 是否需要同步影响

确认结果：A

结论：
api_find_report 需要同步影响。

影响：
- api_find_report 不再是 Unknown。
- api_find_report 应进入 In Scope。
- Requirement Card 阶段只确认需求范围，不定义 API 实现方式。

------------------------------------------------------------

U-008：表形式 CSV / 集計 CSV 是否都属于本次范围

确认结果：B

结论：
表形式 CSV + 集計 CSV 都属于范围。

影响：
- 表形式 CSV 与 集計 CSV 都应进入 In Scope。
- Acceptance Criteria 需要补充：
  - 表形式 CSV 中能输出「発着信日時（最新）」
  - 集計 CSV 中能输出「発着信日時（最新）」

============================================================
B. 仍未确认事项
============================================================

U-009：多语言文案 / 翻译范围
状态：未确认，继续保留 Unknown。

U-010：列宽 / 排序 / 筛选默认行为
状态：未确认，继续保留 Unknown。

U-011：权限可见性
状态：未确认，继续保留 Unknown。

U-012：完整菜单操作路径
状态：未确认，继续保留 Unknown。

U-013：用户补充原话中的「* 集計レポート」是明确业务要求还是调查线索
状态：已由 U-001 / U-002 间接确认。
结论：集計レポート 是明确业务范围，不再只是调查线索。

============================================================
C. Round 3 Freeze 合并规则
============================================================

1. Round 3 Frozen Requirement Card 必须将以下内容从 Unknowns 移入 In Scope：
   - 集計レポート
   - CSV
   - 表形式 CSV
   - 集計 CSV
   - api_find_report

2. Round 3 Frozen Requirement Card 必须将以下口径写为已确认：
   - 「最新」口径：沿用现有「顧客最新情報」既存链路中的“最新”定义。
   - 无数据时显示：`-`
   - 順番：包含自定义项目后的全列表最后。

3. Round 3 Frozen Requirement Card 必须删除或改写以下 Unknown：
   - 集計レポート 是否属于范围
   - CSV 是否属于范围
   - api_find_report 是否同步影响
   - 表形式 CSV / 集計 CSV 是否属于范围
   - 用户补充原话中的「* 集計レポート」是否只是调查线索

4. Round 3 Frozen Requirement Card 仍必须保留以下 Unknown：
   - 多语言文案 / 翻译范围
   - 列宽 / 排序 / 筛选默认行为
   - 权限可见性
   - 完整菜单操作路径

5. Requirement Card 阶段仍禁止：
   - 写代码
   - 写 SQL
   - 写实现方案
   - 生成 patch / diff
   - 进入 Engineering Requirement Card

---

## 4. M1 Summary

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


---

## 5. Round 1 Selected Engineering Requirement Card

# Engineering Requirement Card

## 1. Source Inputs

- **Frozen Requirement Card (M1 最终产物)**
  路径：`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/round-3/12-frozen-requirement-card.md`
  角色：业务需求最高优先级输入，原样保留，不改写。

- **Code Investigation Report**
  路径：`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/material/02-code-investigation-report-1.md`
  角色：代码事实来源；提供工程约束依据；不作为实现指令。

- **Confirmed Unknowns Before Freeze**
  路径：`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/round-2/12-confirmed-unknowns.txt`
  角色：M1 阶段已确认事项来源；其确认结论必须升格为 confirmed engineering requirements。

- **M1 Summary**
  路径：`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/M1_SUMMARY.md`
  角色：M1 阶段过程与结论概览，作为本卡的上下文背景。

---

## 2. Requirement Summary

在 `admin/customer_contact_history_reports/add` 当 `target=顧客最新情報` 时，于「項目（*必須）」中追加 `発着信日時（最新）` 项目，并使其在表形式レポート / 集計レポート / 表形式 CSV / 集計 CSV / `api_find_report` 五条输出链路中沿用既存「顧客最新情報」链路的"最新"口径同步呈现，无数据时显示 `-`。

---

## 3. Confirmed Business Requirements

> 来源：Frozen Requirement Card（M1 最终产物）。原样保留，不改写。

- **CBR-01**（来源：Frozen 第 7 章 In Scope）：在 `admin/customer_contact_history_reports/add` 页面、当対象为「顧客最新情報」时，追加 `発着信日時（最新）` 这一项目。
- **CBR-02**（来源：Frozen 第 7 章）：该项目出现在 `項目（*必須）` 中，并具有 `出力 項目名`、`表示名`、`順番` 配置表现。
- **CBR-03**（来源：Frozen 第 6 章 / U-005）：`順番` 位于包含自定义项目后的全列表最后一位。
- **CBR-04**（来源：Frozen 第 7 章 / U-001）：表形式レポート 支持 `発着信日時（最新）`。
- **CBR-05**（来源：Frozen 第 7 章 / U-001 / U-002）：集計レポート 支持 `発着信日時（最新）`。
- **CBR-06**（来源：Frozen 第 7 章 / U-006 / U-008）：表形式 CSV 输出支持 `発着信日時（最新）`。
- **CBR-07**（来源：Frozen 第 7 章 / U-008）：集計 CSV 输出支持 `発着信日時（最新）`。
- **CBR-08**（来源：Frozen 第 7 章 / U-007）：`api_find_report` 同步输出 `発着信日時（最新）`。
- **CBR-09**（来源：Frozen 第 6 章 / U-003）：该项目展示的值，沿用现有「顧客最新情報」既存链路中的"最新"定义。
- **CBR-10**（来源：Frozen 第 6 章 / U-004）：当客户无発着信履歴数据时，该项目显示 `-`。
- **CBR-11**（来源：Frozen 第 6 章）：在 `出力 項目名` 列与 `表示名` 列均显示 `発着信日時（最新）`。
- **CBR-12**（来源：Frozen 第 7 章）：与该配置页配对的编辑页 / 查看页中，该项目的可见性与已保存状态应保持一致。

---

## 4. Engineering Scope

> 工程影响范围按"输出链路"维度展开。每项均区分「来源类型」。

### 4.1 表形式レポート
- **影响层**：配置页（add/edit/view）→ 字段保存 → 报表查询 → 报表查看画面。
- **配置侧（已确认）**：`target=顧客最新情報` 时，「項目（*必須）」中追加 `発着信日時（最新）`，位于"包含自定义项目后的全列表最末"。来源：CBR-01 / CBR-02 / CBR-03。
- **查询侧（来自代码调查 + 待 M3 评估）**：表形式 target=2 当前查询链路涉及 `customer_contacts` + `customer_notes(max id)` + `cdr` 关联（来自代码事实，详见第 6 章）。本卡只确认"该项目展示值需沿用既存「顧客最新情報」链路'最新'口径"（CBR-09）；具体 SQL / join 调整方案不在本卡阶段定义。
- **画面侧（已确认）**：勾选后表形式レポート查看画面能展示该项目（CBR-04）。

### 4.2 集計レポート
- **影响层**：配置页（X/Y/V 选择形式）→ 集計查询 → 集計画面。
- **配置侧（来自代码调查 + 工程不确定）**：代码事实显示「項目（*必須）」仅在 type=1（表形式）显示，集計（type=2）使用 X/Y/V 下拉（详见第 6 章）。本卡确认"集計レポート 必须支持 `発着信日時（最新）`"（CBR-05）；该项目以何种 UI 形态出现在集計配置侧（X/Y/V 下拉的哪一类、是否同时支持）属于工程未知，列入第 9 章。
- **查询侧（工程约束）**：代码事实显示 target=2 的集計 SQL 当前未 join `cdr`（详见第 6 章 / 第 7 章）。引入该项目对集計查询链路有结构性影响，需在 M3 阶段单独评估。
- **画面侧（已确认）**：集計レポート 能展示 `発着信日時（最新）`（CBR-05）。

### 4.3 CSV 输出
- **影响层**：表形式 CSV、集計 CSV 两条独立下载链路。
- **表形式 CSV（已确认）**：输出 `発着信日時（最新）`，取值口径与画面一致（CBR-06、CBR-09、CBR-10）。
- **集計 CSV（已确认）**：输出 `発着信日時（最新）`，取值口径与画面一致（CBR-07、CBR-09、CBR-10）。
- **CSV 标题（来自代码调查）**：CSV 标题取字段 `name`（显示名），需保证与配置侧 `表示名` 一致。

### 4.4 api_find_report
- **影响层**：对外 API 输出。
- **已确认**：基于已配置字段输出 CSV 形态结果，需同步包含 `発着信日時（最新）`，取值口径与画面 / CSV 一致（CBR-08、CBR-09、CBR-10）。
- **工程约束**：本卡不定义 API schema 变更细节；M3 阶段需确认 `api_find_report` 在 target=2 场景下的字段映射策略。

---

## 5. Affected Outputs

> 受影响的输出类型清单（仅列已确认的输出面）。

| 编号 | 输出类型 | 来源类型 | 备注 |
|------|----------|----------|------|
| AO-01 | 表形式レポート 配置页（add） | 已确认 | 「項目（*必須）」中新增项 |
| AO-02 | 表形式レポート 配置页（edit / view） | 已确认 | 与 add 页可见性 / 已保存状态保持一致（CBR-12） |
| AO-03 | 表形式レポート 报表查看画面 | 已确认 | CBR-04 |
| AO-04 | 集計レポート 配置侧 | 已确认（具体 UI 形态待定） | CBR-05；UI 形态见 9.U-E-01 |
| AO-05 | 集計レポート 报表查看画面 | 已确认 | CBR-05 |
| AO-06 | 表形式 CSV | 已确认 | CBR-06 |
| AO-07 | 集計 CSV | 已确认 | CBR-07 |
| AO-08 | api_find_report | 已确认 | CBR-08 |

---

## 6. Code Investigation Facts

> 来源：Code Investigation Report。**仅作为代码事实陈列**，不含推测，不直接升格为实现指令。

- **CIF-01**：`admin/customer_contact_history_reports/add` 的「項目（*必須）」由 controller 内系统字段数组 + 自定义字段数组生成；页面本身不硬编码具体业务字段。
  来源：`app/controllers/customer_contact_history_reports_controller.php:112`、`app/views/customer_contact_history_reports/admin_add.thtml:81`
- **CIF-02**：当前 `target=2（顧客最新情報）` 的系统字段列表里没有 `Cdr.start_date`；`target=1（顧客対応履歴）` 才有。
  来源：`app/controllers/customer_contact_history_reports_controller.php:198, :128`
- **CIF-03**：报表输出字段来自 `CustomerContactHistoryReportField`（保存的勾选字段），并在列表展示 / API / CSV 下载时按 `field_name` 映射取值。
  来源：`app/controllers/customer_contact_history_reports_controller.php:314, :617, :1656`
- **CIF-04**：`target=2` 的"最新信息"当前是通过"每个客户取 `customer_notes` 最大 `id`"来关联最新 note，再 left join 到 cdr，并非按 `Cdr.start_date` 取最新。
  来源：`app/controllers/customer_contact_history_reports_controller.php:704`
- **CIF-05**：`/admin/cdr/index` 的「発着信時間」就是 `cdr.start_date` 字段。
  来源：`app/controllers/cdr_controller.php:690`、`app/locale/ja/ApplicationResources.properties:1445`
- **CIF-06**：`項目（*必須）` 仅在表形式（type=1）显示；集計使用 X/Y/V 下拉。
  来源：`app/views/customer_contact_history_reports/admin_add.thtml:81, :159`
- **CIF-07**：target=2 的集計 SQL 当前没有 join `cdr`。
  来源：`app/controllers/customer_contact_history_reports_controller.php:823`
- **CIF-08**：CSV 共两类——表形式 `__downloadReportDetail`、集計 `__downloadMatrixTable`；新增字段会影响对应 CSV 列。
  来源：`app/controllers/customer_contact_history_reports_controller.php:1580, :1486`
- **CIF-09**：CSV 标题取字段 `name`（显示名），不是 `field_name`。
  来源：`app/controllers/customer_contact_history_reports_controller.php:1612`
- **CIF-10**：`api_find_report` 也基于已配置字段输出 CSV。
  来源：`app/controllers/customer_contact_history_reports_controller.php:1791`
- **CIF-11**：在该 controller 未发现 Excel/PDF 输出实现；未发现与 `CustomerContactHistoryReport` 直接关联的 shell/cron 调用链；未发现该报表输出直连邮件配信。
  来源：Code Investigation Report 第 8 节
- **CIF-12**：无值时多数分支输出空字符串；部分枚举输出 `N/A` 或 `global.blank`（即 `（空白）`），即既存空值显示规则不统一。
  来源：`app/controllers/customer_contact_history_reports_controller.php:1666, :1736`、`app/locale/ja/ApplicationResources.properties:288`
- **CIF-13**：順番默认值由 `$num` 递增，"放最后"依赖字段被追加在数组尾部。
  来源：`app/views/customer_contact_history_reports/admin_add.thtml:105`
- **CIF-14**：`privilege.conf` 中存在 `admin_report_detail_download` 权限项，但 controller 未实现同名 action。
  来源：`app/config/privilege.conf:121`
- **CIF-15**：`/admin/cdr/index` 默认排序为第 1 列（id）降序，`CDR_SORT=0` 时强制允许第 1 列排序。
  来源：`app/controllers/cdr_controller.php:61, :77`、`app/webroot/js/new_admin/cdr/index.js:38`、`app/config/sctel.conf:325`

---

## 7. Engineering Constraints

> 从代码调查中发现的工程约束。来源类型均标注。

- **EC-01（来自代码调查）**：「項目（*必須）」字段由 controller 内 `tableSystemFields` 数组生成（CIF-01）。新增项目仅在该数组扩展时影响表形式配置侧；不会自动影响集計 X/Y/V 下拉（CIF-06）。
- **EC-02（来自代码调查）**：表形式 target=2 的"最新"既存口径基于 `customer_notes.max(id)`（CIF-04），与"按 `cdr.start_date` 取最大值"不等价。已确认采用既存链路口径（CBR-09），M3 必须严格沿用既存口径，不得改写为按 `start_date` 取最新。
- **EC-03（来自代码调查）**：集計 target=2 SQL 当前无 `cdr` join（CIF-07）。集計链路引入 `発着信日時（最新）` 必然涉及查询链路结构性扩展，影响面大于表形式追加一列。
- **EC-04（来自代码调查）**：CSV 标题取 `name`（显示名）而非 `field_name`（CIF-09）。新增字段的 `name` / `field_name` 命名一致性需在 M3 落定，避免画面与 CSV 标题分歧。
- **EC-05（来自代码调查）**：既存空值显示规则不统一（空字符串 / `N/A` / `（空白）`，CIF-12）。本卡 CBR-10 已确认无数据显示 `-`，与既存任一规则均不同；M3 必须在 5 条输出链路上独立处理 `-` 显示，不能依赖既存 fallback。
- **EC-06（来自代码调查）**：配置页与下游输出之间通过 `field_name` 映射传递（CIF-03）。新增 `発着信日時（最新）` 需要在 5 条输出链路（表形式画面、集計画面、表形式 CSV、集計 CSV、api_find_report）的 `field_name → value` 映射点逐一新增分支。
- **EC-07（来自代码调查）**：順番依赖数组追加顺序（CIF-13）。CBR-03"包含自定义项目后的全列表最后"对追加位置有方向性约束：必须在系统字段 + 自定义字段拼接完成后追加。
- **EC-08（来自代码调查）**：未发现 Excel / PDF / batch / cron / 邮件相关链路（CIF-11），可作为 Out of Scope 的事实依据。

---

## 8. Out of Scope

> 来源：Frozen Requirement Card 第 8 章 + 代码调查事实。

- **OOS-01（已确认）**：搜索条件调整不在本次范围内。
- **OOS-02（已确认）**：Excel / PDF 输出不在本次范围内（与 CIF-11 一致）。
- **OOS-03（已确认）**：batch / cron 不在本次范围内（与 CIF-11 一致）。
- **OOS-04（已确认）**：邮件配信内容不在本次范围内（与 CIF-11 一致）。
- **OOS-05（已确认）**：`/admin/cdr/index` 自身不作为本次主动修改对象，仅作为参考页面。
- **OOS-06（已确认）**：本次不主动改权限控制本身（注：`privilege.conf` 中的 `admin_report_detail_download` 历史遗留项不在本次清理范围内，CIF-14）。
- **OOS-07（M2 边界）**：本卡不输出 SQL、字段命名、patch / diff、性能设计、i18n 实现细节、API schema 变更细节，留待 M3。
- **OOS-08（M2 边界）**：本卡不改写或重新拍板 M1 已确认的口径。

---

## 9. Engineering Unknowns

> 仍需在 M3 之前确认的工程事项。**禁止脑补**。

### 9.1 来自 M1 未收敛 Unknown（继承）
- **U-B-01（业务侧）**：多语言文案 / 翻译范围（仅日文 vs. 多语言）。影响：`name` / `表示名` / 提示文案 / CSV 标题翻译范围。
- **U-B-02（业务侧）**：列宽 / 排序 / 筛选默认行为是否需指定。影响：表形式画面、集計画面、CSV 列定义。
- **U-B-03（业务侧）**：权限可见性是否存在角色级控制。影响：5 条输出链路上各自的可见性策略。
- **U-B-04（业务侧）**：完整菜单操作路径未确认。影响：验收步骤描述与回归用例。

### 9.2 工程层 Unknown（来自代码调查衍生，需 M3 之前确认）
- **U-E-01（工程未知）**：集計レポート 配置侧（X/Y/V 下拉）中，`発着信日時（最新）` 应作为 X 轴 / Y 轴 / V 值中的哪一类（或若干类）出现。CIF-06 表明集計配置形式与表形式不同，CBR-05 仅确认"集計需支持"，未明确其在 X/Y/V 中的位置归属。
- **U-E-02（工程未知）**：歧义 1（来自 Frozen 风险章）：「発信 / 発着信」与「日付 / 日時」两个维度的最终落地口径。本卡已确认"沿用既存「顧客最新情報」链路口径"（CBR-09），但既存链路（CIF-04，`customer_notes.max(id)` → cdr）实际产生的取值在通话方向（発信 / 着信 / 双向）与时间粒度（日 / 日時）上对应何种结果，需 M3 阶段以既存链路实际行为为准明确，不得由实现侧自行解释。
- **U-E-03（工程未知）**：`api_find_report` 在 target=2 场景下，新增字段的对外字段名（`field_name` 或 `name`）与 CSV 字段映射策略需在 M3 之前与对外接口契约方对齐。
- **U-E-04（工程未知）**：5 条输出链路上 `-` 显示的统一实现位置（在数据层统一，还是在各输出层各自处理）需在 M3 决定；本卡仅约束最终行为一致（CBR-10）。

---

## 10. Acceptance Mapping

> 业务验收 (Frozen 第 10 章 AC) → 工程验收要点。本卡只做映射，不新增超出 Frozen 的业务 AC。

| Frozen AC | 工程验收要点 | 涉及输出 | 关联 CBR / EC |
|-----------|--------------|----------|----------------|
| AC-001 | `target=顧客最新情報` 时配置页字段列表包含新项 | AO-01 | CBR-01 / EC-01 |
| AC-002 | 配置页 `出力 項目名` 与 `表示名` 列均渲染为 `発着信日時（最新）` | AO-01 | CBR-11 |
| AC-003 | 順番渲染位置在系统字段 + 自定义字段拼接末尾 | AO-01 | CBR-03 / EC-07 |
| AC-004 | 勾选并保存后 `CustomerContactHistoryReportField` 中存在该字段记录 | AO-01 / AO-02 | CBR-12 / EC-06 |
| AC-005 | 表形式レポート 查看画面渲染该列 | AO-03 | CBR-04 / EC-06 |
| AC-006 | 集計レポート 能选择并展示该项目 | AO-04 / AO-05 | CBR-05 / EC-03 / U-E-01 |
| AC-007 | 有数据时取值与既存「顧客最新情報」链路"最新"口径一致 | AO-03 / AO-05 / AO-06 / AO-07 / AO-08 | CBR-09 / EC-02 |
| AC-008 | 无発着信履歴数据时 5 条输出链路均显示 `-` | AO-03 / AO-05 / AO-06 / AO-07 / AO-08 | CBR-10 / EC-05 / U-E-04 |
| AC-009 | 表形式 CSV 列输出 `発着信日時（最新）`，取值与 AC-007 / AC-008 一致 | AO-06 | CBR-06 / EC-04 / EC-06 |
| AC-010 | 集計 CSV 列输出 `発着信日時（最新）`，取值与 AC-007 / AC-008 一致 | AO-07 | CBR-07 / EC-04 / EC-06 |
| AC-011 | `api_find_report` 输出 `発着信日時（最新）`，取值与 AC-007 / AC-008 一致 | AO-08 | CBR-08 / EC-06 / U-E-03 |
| AC-Regression-001 | 未勾选时既存输出无差异 | 全部 | OOS-08 |
| AC-Regression-002 | 既存「項目（*必須）」原有项目显示名 / 順番 / 勾选行为不变 | AO-01 | EC-01 / EC-07 |
| AC-Regression-003 | 「顧客対応履歴」侧発着信時間相关项目行为不变（target=1） | AO-03 / AO-06 | CIF-02 |
| AC-Regression-004 | `/admin/cdr/index` 行为不变 | — | OOS-05 |
| AC-Regression-005 | 表形式 CSV / 集計 CSV / `api_find_report` 既有字段输出不变 | AO-06 / AO-07 / AO-08 | EC-06 |

> 业务侧 Unknown（U-B-01 ~ U-B-04）确认后需补对应 AC，本卡不预置。

---

## 11. Risks / Cautions

- **R-01（来源：Frozen 风险 1 + EC-02）**：既存「顧客最新情報」链路"最新"口径基于 `customer_notes.max(id)`（CIF-04），与一般直觉的"按発着信時間最新"不一致。M3 实现侧不得自行用 `cdr.start_date DESC` 替换该口径；如发现既存链路在某些数据形态下产生用户难以理解的"最新"结果，需上报业务侧而非实现侧自行修正。
- **R-02（来源：Frozen 风险 2 + EC-03）**：集計 target=2 当前无 `cdr` join（CIF-07）。引入新字段会扩展集計查询结构，性能 / 数据范围 / NULL 处理影响面均大于表形式；M3 需对集計链路单独评估，不得套用表形式实现方式。
- **R-03（来源：Frozen 风险 3 + EC-07）**：「順番最后」依赖追加顺序（CIF-13），且自定义项目数量随租户 / 配置变化。验收时以"当前实例下全列表最末"为准，不得按固定下标判定。
- **R-04（来源：Frozen 风险 4 + EC-05）**：`-` 显示需在 5 条输出链路（画面 ×2 + CSV ×2 + API ×1）保持一致；既存空值规则本身不统一（CIF-12），实现层不能依赖任何既存 fallback，必须在 M3 明确统一处理点。
- **R-05（来源：Frozen 风险 5 + EC-06）**：5 条输出链路通过 `field_name → value` 映射独立分发（CIF-03），存在某条链路漏接的"做一半"风险。M3 必须将 5 处映射作为一组验收对象，缺一不可。
- **R-06（来源：Frozen 风险 6 + CIF-15）**：`/admin/cdr/index` 默认按 `id DESC` 排序，并不严格等同于"按 `start_date` 最新"。业务侧若以该参考页视觉顺序作为对照，可能与既存链路口径产生分歧；以 CBR-09 既存链路口径为准，CDR 参考页仅作 UI 参照。
- **R-07（来源：Frozen 风险 7 + U-B-03）**：权限可见性未澄清，若 M3 之前未确认，按全员一致可见处理存在返工风险。
- **R-08（来源：Frozen 歧义 1 + U-E-02）**：「発信 / 発着信」与「日付 / 日時」两层口径未在 M1 拍板。M3 必须先以既存链路实际行为澄清，再决定项目展示口径；不得由实现侧自行选择"取 cdr 哪一字段、哪一方向"。
- **R-09（来源：Frozen 歧义 2）**：用户补充原话中的 `cdr参照` 是线索而非冻结口径；不能以 cdr 表的字段直觉作为本项目取值依据。
- **R-10（工程层）**：CSV 标题取 `name`（CIF-09 / EC-04）。`name`（显示名）与配置侧 `表示名` 必须严格同源，否则下载文件标题与画面表示不一致。

---

## 12. Handoff to M3 Code-grounded Plan

> 输入提醒，**非实现方案**。

- **H-01**：以本卡第 3 章 Confirmed Business Requirements 与第 7 章 Engineering Constraints 为 M3 起点，不得改写。
- **H-02**：M3 必须严格沿用 CBR-09 / EC-02 既存「顧客最新情報」链路"最新"口径（即 CIF-04 所示链路），不得自行替换为 `cdr.start_date` 取最大值。
- **H-03**：M3 必须将 5 条输出链路（AO-03、AO-05、AO-06、AO-07、AO-08）作为一组验收对象处理，逐路径核对取值口径与 `-` 显示一致性。
- **H-04**：M3 评估集計レポート 链路（EC-03）时，需独立产出对集計查询链路的影响范围分析，不得默认沿用表形式实现方式。
- **H-05**：M3 进入实现前需先解决工程层 Unknown：
  - U-E-01（集計侧 X/Y/V 归属）
  - U-E-02（既存链路在発信/着信、日/日時 上的实际取值表现）
  - U-E-03（`api_find_report` 字段映射策略）
  - U-E-04（`-` 显示统一实现位置）
- **H-06**：业务侧 Unknown（U-B-01 ~ U-B-04）一经确认，M3 需补充对应 AC 与实现处理点；未确认前不得提前拍板。
- **H-07**：M3 不得将 Code Investigation Report 中"可能相关文件"升格为"必须修改文件"清单；具体修改范围需基于 M3 自行的 code-grounded 评估。
- **H-08**：M3 应核对新增字段的 `field_name` 与 `name`（显示名）一致性策略（EC-04），覆盖配置页、画面、CSV 标题、API 字段名四处。
- **H-09**：M3 不得在 Plan 阶段输出 patch / diff / 完整 SQL；仅描述影响点、修改方向与验收要点。
- **H-10**：Out of Scope（第 8 章）项不得在 M3 阶段被悄悄扩入。

---

## 6. Round 1 Decision

# Engineering Requirement Card Decision

## Decision Result

**Winner: claude**

## Score Summary

| Candidate | Total Score | Key Strengths | Key Weaknesses |
|-----------|-------------|---------------|----------------|
| codex | 4.35 | 来源类型徽标可追溯性高；零边界越界；Risks 章节保留歧义不擅自消解；§12 明确告诉 M3「候选调查面 ≠ 必须修改文件清单」 | 缺少 ID 体系，AC 与 Constraint/Output 间为叙述性映射；Code Investigation Facts 未带 `file:line`；未细分业务/工程 Unknown |
| claude | 5.00 | 完整 ID 体系（CBR/EC/AO/CIF/U-B/U-E/R/H）；每条 CIF 带 `file:line`；独创业务 Unknown（U-B）与工程 Unknown（U-E）双层分离，主动识别 U-E-01（X/Y/V 归属）、U-E-04（`-` 显示统一位置）；§12 Handoff 10 条约束明确 | 篇幅最长阅读成本相对高；个别 EC 条目（如 EC-05）接近"实现指引"边缘但仍守在约束层 |
| deepseek | 3.25 | 输出结构齐全；AC Mapping 用表格呈现；保留"発信 vs 発着信"歧义至 Unknowns；继承 Frozen Card 风险项 | **边界违规**：AC-007 把"`customer_notes.id` 最大 → `cdr.start_date`"推测升格为业务验收事实；§7 擅自承诺"至少日文"多语言；§12 接近指定实现方向；引用了 M1 不存在的 U-009/U-010/U-011/U-012（脑补来源） |

## Tie-breaker Analysis

不适用——claude 以总分 5.00 显著领先（codex 4.35、deepseek 3.25），无平局。

## Winner Justification

claude 在全部六个维度上同时取得满分，且**唯一不存在边界违规**：

1. **requirement_alignment (5/5)**：通过 CBR-01~CBR-12 完整保留 Frozen Requirement Card 的业务表述，未做任何改写。
2. **code_fact_grounding (5/5)**：CIF-01~CIF-15 每条均带 `file:line` 行号锚点，事实与推测严格区分——这是 codex（缺行号）与 deepseek（推测升格为事实）都无法做到的。
3. **engineering_scope_clarity (5/5)**：表形式 / 集計 / CSV / api_find_report 四领域分节展开，明确点出"集計侧 X/Y/V 与表形式独立选择入口"这一关键工程差异。
4. **boundary_control (5/5)**：零 SQL / 零 patch / 零字段命名方案；EC 章节虽贴近实现指引但严守约束层语义。与 deepseek 形成最强对比——deepseek 的 AC-007 / §7 / §12 均有滑移。
5. **unknowns_quality (5/5)**：U-B vs U-E 双层 Unknown 是独家创新，U-E-01（集計 X/Y/V 归属）、U-E-04（`-` 显示统一实现位置）是只有结合代码事实才能识别出的工程未知。
6. **m3_handoff_readiness (5/5)**：CBR/EC/AO/CIF/U-B/U-E/R/H 完整 ID 体系使 AC Mapping 交叉引用最严密；§12 Handoff 10 条约束直接限定 M3 不得升格候选文件、不得输出 patch/SQL。

而 deepseek 因 AC-007 将代码推测升格为业务验收事实、§7 擅自承诺多语言范围、§12 措辞接近指定实现方向、且引用 M1 不存在的 U-009~U-012 ID（凭空构造），触发**规则 1（违规必败）**层面的严重扣分（boundary_control 仅 2 分）；codex 虽零越界、纪律性优秀，但缺 ID 体系与文件行号锚点，颗粒度不足，无法支撑 M3 的精确引用需求。

按**规则 2（总分优先）**：claude(5.00) > codex(4.35) > deepseek(3.25)，claude 胜出。

## Next Step

将 claude 候选作为输入，运行 `05-merge-selected-card.md` 生成最终 Engineering Requirement Card。

---

## 7. Round 1 Score

{
  "scores": {
    "codex": {
      "requirement_alignment": 5,
      "code_fact_grounding": 4,
      "engineering_scope_clarity": 4,
      "boundary_control": 5,
      "unknowns_quality": 4,
      "m3_handoff_readiness": 4,
      "total_weighted_score": 4.35
    },
    "claude": {
      "requirement_alignment": 5,
      "code_fact_grounding": 5,
      "engineering_scope_clarity": 5,
      "boundary_control": 5,
      "unknowns_quality": 5,
      "m3_handoff_readiness": 5,
      "total_weighted_score": 5.00
    },
    "deepseek": {
      "requirement_alignment": 4,
      "code_fact_grounding": 3,
      "engineering_scope_clarity": 4,
      "boundary_control": 2,
      "unknowns_quality": 3,
      "m3_handoff_readiness": 3,
      "total_weighted_score": 3.25
    }
  },
  "recommended_winner": "claude",
  "reasoning": "claude 在六个维度上全面领先：(1) requirement_alignment：完全保留 Frozen Requirement Card 的业务表述，通过 CBR-01~CBR-12 显式映射，未做任何改写；(2) code_fact_grounding：CIF-01~CIF-15 每条代码事实均带 `file:line` 行号锚点，事实与推测严格区分；(3) engineering_scope_clarity：表形式 / 集計 / CSV / api_find_report 四领域分节展开，且明确指出集計侧 X/Y/V 与表形式独立选择入口的工程差异；(4) boundary_control：未输出 SQL / patch / diff / 具体字段命名方案，EC 章节虽接近实现指引但严格保持在「约束」层面；(5) unknowns_quality：独创性地将 Unknowns 分为 U-B（业务侧继承自 M1）与 U-E（工程层衍生），主动识别出 U-E-01 集計 X/Y/V 归属、U-E-04 `-` 显示统一实现位置等只在代码事实层面才能发现的工程未知；(6) m3_handoff_readiness：完整 ID 体系（CBR/EC/AO/CIF/U-B/U-E/R/H）使 AC Mapping 表交叉引用最严密，§12 Handoff 10 条约束明确禁止 M3 把候选文件升格为必须修改文件、禁止输出 patch/SQL。codex 纪律性同样优秀且零越界，但缺少 ID 体系与文件行号引用，AC 与约束之间为叙述性映射，颗粒度不足；deepseek 存在多处明确边界违规（AC-007 把 `customer_notes.id 最大 → cdr.start_date` 这一推测升格为业务验收事实、§7 擅自承诺『至少日文』、§12 接近指定实现方向），并引用了 M1 不存在的 U-009/U-010/U-011/U-012 ID（脑补来源），boundary_control 与 code_fact_grounding 均明显扣分。综合加权后 claude(5.00) > codex(4.35) > deepseek(3.25)，推荐 claude 作为 M3 Code-grounded Plan 的主输入。"
}
