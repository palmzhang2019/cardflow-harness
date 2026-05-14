# Model Input

- task_id: 24174-customer-latest-info-add-send-date
- stage: m2-engineering-card
- round: round-1
- model: codex

---

## Instruction

# M2 Engineering Requirement Card Candidate Generator - Round 1

你现在是 Engineering Requirement Card Candidate 生成 Agent。

## 任务
基于以下输入材料，生成一张 Engineering Requirement Card Candidate：

1. Frozen Requirement Card（M1 最终产物）
2. Code Investigation Report（代码调查报告）
3. Confirmed Unknowns（M1 已确认事项）
4. M1 Summary（M1 总结）

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

## 各章节说明

### 1. Source Inputs
列出所有输入材料及其路径，标注每项的角色。

### 2. Requirement Summary
一句话概括工程需求。

### 3. Confirmed Business Requirements
来自 Frozen Requirement Card 的已确认业务需求，原样保留，不改写。

### 4. Engineering Scope
明确工程影响范围：
- 表形式レポート
- 集計レポート
- CSV 出力
- api_find_report
每项需说明具体影响。

### 5. Affected Outputs
列出所有受影响的输出类型。

### 6. Code Investigation Facts
来自代码调查的发现，标注为"代码事实"，不包含推测。

### 7. Engineering Constraints
从代码调查中发现的工程约束。

### 8. Out of Scope
明确不做的事项。

### 9. Engineering Unknowns
仍需确认的工程事项，不能脑补。

### 10. Acceptance Mapping
业务验收标准到工程验收的映射。

### 11. Risks / Cautions
工程风险和注意事项。

### 12. Handoff to M3 Code-grounded Plan
给 M3 的输入提醒，不是实现方案。

## 输出要求
- 只输出 Engineering Requirement Card Candidate 本文
- 不要解释你将如何做
- 不要输出多余寒暄
- 严格遵循 12 章节模板
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

