# Model Input

- task_id: 24174-customer-latest-info-add-send-date
- stage: m2-engineering-card
- round: round-2
- task: comparison

---

## Instruction

# M2 Engineering Requirement Card Candidate Comparison

你现在是 Engineering Requirement Card Comparison Agent。

## 任务
比较多个候选 Engineering Requirement Card，输出结构化比较报告。

## 输入
本目录下的三个候选文件：
- 01-candidate-codex.md
- 02-candidate-claude.md
- 03-candidate-deepseek.md

## 比较维度

### 1. requirement_alignment
是否严格继承 Frozen Requirement Card 的业务需求，不改写。

### 2. code_fact_grounding
是否正确使用 Code Investigation Report 的代码事实，不把推测升格为事实。

### 3. engineering_scope_clarity
是否清楚表达工程影响范围，包括表形式、集計、CSV、api_find_report。

### 4. boundary_control
是否避免进入 Plan / SQL / patch / diff / 具体实现方案。

### 5. unknowns_quality
是否保留真正需要确认的工程 Unknowns，不重复 M1 已确认事项。

### 6. m3_handoff_readiness
是否适合作为 M3 Code-grounded Plan 的输入。

## 输出格式

```markdown
# Engineering Requirement Card Comparison Report

## Candidates Overview
（简要列出每个候选的优缺点）

## Dimension Scores
| Dimension | codex | claude | deepseek |
|-----------|-------|--------|----------|
| requirement_alignment | | | |
| code_fact_grounding | | | |
| engineering_scope_clarity | | | |
| boundary_control | | | |
| unknowns_quality | | | |
| m3_handoff_readiness | | | |

## Strengths and Weaknesses
### codex
### claude
### deepseek

## Recommended Priority
（基于综合评估的推荐顺序）
```

## 注意事项
- 客观比较，不偏袒任何一个模型
- 重点关注是否遵守 M2 约束
- 标记任何违规内容（如写了 SQL、代码、具体实现方案）
---

## Candidate: codex

# Engineering Requirement Card Candidate

## 1. Source Inputs

- `Frozen Requirement Card`  
来源类型：`Confirmed Business Source`  
角色：业务需求最高优先级输入；本卡不得改写其业务需求与已确认口径。

- `Code Investigation Report`  
来源类型：`Code Fact Source`  
角色：仅作为代码事实与工程约束来源；不作为实现指令。

- `Confirmed Unknowns`  
来源类型：`Confirmed Decision Source`  
角色：M1 已确认事项必须在本卡中升格为 confirmed engineering requirements。

- `M1 Summary`  
来源类型：`Process Context`  
角色：提供 M1 冻结背景与边界提醒。

- `Round 1 Selected Engineering Requirement Card`  
来源类型：`Baseline Candidate`  
角色：作为本轮改进基线，继承其结构优点，修正评分反馈指出的问题。

- `Round 1 Decision`  
来源类型：`Review Feedback`  
角色：指出优先改进点，尤其是 `ID 体系`、`file:line grounding`、`业务 Unknown / 工程 Unknown 分层`、`集計作用域澄清`。

- `Round 1 Score`  
来源类型：`Review Feedback`  
角色：本轮重点提升 `requirement_alignment`、`code_fact_grounding`、`engineering_scope_clarity`、`boundary_control`、`unknowns_quality`、`m3_handoff_readiness`。

- 与 Round 1 版本的差异  
来源类型：`This Candidate Revision Note`  
本版明确改进如下：
- 所有代码事实改为带 `file:line` 锚点。
- Unknowns 明确拆分为 `U-B`（业务侧）与 `U-E`（工程侧）。
- `表形式レポート` 与 `集計レポート` 的配置入口、查询链路、输出链路分开表达，不再混写。
- 权限相关表述去除“Unknown / Out of Scope”混淆：`权限可见性要求` 仍是 Unknown，但 `权限控制机制本身的主动改修` 不在本卡确认范围。
- 明确将 `CSV`、`表形式 CSV`、`集計 CSV`、`api_find_report` 作为独立受影响输出面，而非附带提及。

## 2. Requirement Summary

来源类型：`Frozen Requirement Card + Confirmed Unknowns`

在 `admin/customer_contact_history_reports/add` 中，当対象为「顧客最新情報」时，需要新增一个名为 `発着信日時（最新）` 的项目，使其能够进入既有报表配置与输出链路，并覆盖以下范围：`表形式レポート`、`集計レポート`、`表形式 CSV`、`集計 CSV`、`api_find_report`。该项目的取值口径已确认应`沿用现有「顧客最新情報」既存链路中的“最新”定义`；当客户无発着信履歴数据时显示 `-`；其 `順番` 为`包含自定义项目后的全列表最后`。

与 Round 1 版本的差异：
- 本版不把“集計支持”笼统写成“同表形式一样追加字段”，而是明确保留其配置形态与链路差异。
- 本版不把代码调查中的候选修改面写成必须修改文件。
- 本版把“展示该字段”与“该字段值如何遵循既存最新口径”继续分离表述，避免把推测升格为事实。

## 3. Confirmed Business Requirements

- `CBR-01`  
来源类型：`Frozen Requirement Card`  
在 `admin/customer_contact_history_reports/add` 页面、当対象为「顧客最新情報」时，追加 `発着信日時（最新）` 这一项目。

- `CBR-02`  
来源类型：`Frozen Requirement Card`  
该项目出现在 `項目（*必須）` 相关配置链路中，并具有 `出力 項目名`、`表示名`、`順番` 的配置表现。

- `CBR-03`  
来源类型：`Frozen Requirement Card + U-005 Confirmed`  
`順番` 位于包含自定义项目后的全列表最后。

- `CBR-04`  
来源类型：`Frozen Requirement Card + U-001 Confirmed`  
`表形式レポート` 支持 `発着信日時（最新）`。

- `CBR-05`  
来源类型：`Frozen Requirement Card + U-001/U-002 Confirmed`  
`集計レポート` 支持 `発着信日時（最新）`。

- `CBR-06`  
来源类型：`Frozen Requirement Card + U-006/U-008 Confirmed`  
`表形式 CSV` 支持输出 `発着信日時（最新）`。

- `CBR-07`  
来源类型：`Frozen Requirement Card + U-008 Confirmed`  
`集計 CSV` 支持输出 `発着信日時（最新）`。

- `CBR-08`  
来源类型：`Frozen Requirement Card + U-007 Confirmed`  
`api_find_report` 需要同步输出 `発着信日時（最新）`。

- `CBR-09`  
来源类型：`Frozen Requirement Card + U-003 Confirmed`  
该项目展示值沿用现有「顧客最新情報」既存链路中的“最新”定义。

- `CBR-10`  
来源类型：`Frozen Requirement Card + U-004 Confirmed`  
当客户无発着信履歴数据时，该项目显示 `-`。

- `CBR-11`  
来源类型：`Frozen Requirement Card`  
在 `出力 項目名` 列与 `表示名` 列均显示 `発着信日時（最新）`。

- `CBR-12`  
来源类型：`Frozen Requirement Card`  
与该配置页配对的编辑页 / 查看页中，该项目的可见性与已保存状态应保持一致。

## 4. Engineering Scope

### 4.1 表形式レポート

- `ES-T-01`  
来源类型：`Confirmed Requirement`  
配置侧纳入范围：当 `target=顧客最新情報` 时，新增 `発着信日時（最新）`，并满足 `出力 項目名`、`表示名`、`順番` 相关确认要求。

- `ES-T-02`  
来源类型：`Code Fact`  
表形式链路包含配置页、字段保存、报表查看画面、表形式 CSV，对应影响不能只停留在 add 页面。

- `ES-T-03`  
来源类型：`Confirmed Requirement`  
表形式输出侧必须支持该项目的展示与导出，并遵循 `CBR-09` 与 `CBR-10`。

### 4.2 集計レポート

- `ES-M-01`  
来源类型：`Confirmed Requirement`  
集計レポート 已确认属于本次范围，不能因为其配置 UI 与表形式不同而被排除。

- `ES-M-02`  
来源类型：`Code Fact`  
集計链路当前不是通过 `項目（*必須）` 表格直接配置，而是通过独立的 X/Y/V 选择链路配置；因此“支持集計”不等于“沿用表形式同一入口”。

- `ES-M-03`  
来源类型：`Confirmed Requirement + Engineering Unknown`  
本卡确认“集計必须支持”，但不在本阶段拍板其在 X/Y/V 中的具体归属或配置形态。

### 4.3 CSV

- `ES-C-01`  
来源类型：`Confirmed Requirement`  
`表形式 CSV` 与 `集計 CSV` 都在范围内，且应分别视为独立输出面核对。

- `ES-C-02`  
来源类型：`Code Fact`  
CSV 标题与字段值映射链路独立存在，不能把“画面已显示”视为“CSV 自然正确”。

- `ES-C-03`  
来源类型：`Confirmed Requirement`  
两类 CSV 都必须遵循 `CBR-09` 的既存最新口径和 `CBR-10` 的 `-` 显示规则。

### 4.4 api_find_report

- `ES-A-01`  
来源类型：`Confirmed Requirement`  
`api_find_report` 明确在范围内，不能作为表形式或 CSV 的附带结果处理。

- `ES-A-02`  
来源类型：`Code Fact`  
`api_find_report` 使用已配置字段输出链路，因此新增项目对 API 输出行为有独立影响面。

- `ES-A-03`  
来源类型：`Confirmed Requirement + Engineering Unknown`  
本卡确认 API 需同步输出，但不在本阶段拍板对外字段细节或契约表达方式。

## 5. Affected Outputs

| ID | 输出面 | 来源类型 | 范围状态 | 说明 |
|---|---|---|---|---|
| `AO-01` | `admin_add` 表形式配置页 | Confirmed | In Scope | 新增项目可见、可选、顺番正确 |
| `AO-02` | `admin_edit` / `admin_view` 配对页面 | Confirmed | In Scope | 与已保存状态保持一致 |
| `AO-03` | 表形式レポート查看画面 | Confirmed | In Scope | 展示 `発着信日時（最新）` |
| `AO-04` | 集計レポート配置侧 | Confirmed + Unknown | In Scope | 必须支持；具体 X/Y/V 归属仍未知 |
| `AO-05` | 集計レポート查看画面 | Confirmed | In Scope | 展示 `発着信日時（最新）` |
| `AO-06` | 表形式 CSV | Confirmed | In Scope | 输出该项目 |
| `AO-07` | 集計 CSV | Confirmed | In Scope | 输出该项目 |
| `AO-08` | `api_find_report` | Confirmed | In Scope | 同步输出该项目 |
| `AO-09` | `/admin/cdr/index` | Code Fact | Reference Only | 仅参考，不是主动修改对象 |

与 Round 1 版本的差异：
- 本版把 `AO-04` 单独列为“集計配置侧”，避免把集計支持误写成表形式配置表的自然延伸。
- 本版把 `api_find_report` 提升为独立输出面，而非附带在 CSV 后描述。

## 6. Code Investigation Facts

- `CIF-01`  
来源类型：`Code Fact`  
`admin/customer_contact_history_reports/add` 的「項目（*必須）」由 controller 内系统字段数组与自定义字段数组生成，页面本身不硬编码具体业务字段。  
代码锚点：[customer_contact_history_reports_controller.php:112](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php:112), [admin_add.thtml:81](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml:81)

- `CIF-02`  
来源类型：`Code Fact`  
当前 `target=2（顧客最新情報）` 的系统字段列表里没有 `Cdr.start_date`；`target=1（顧客対応履歴）` 才有。  
代码锚点：[customer_contact_history_reports_controller.php:198](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php:198), [customer_contact_history_reports_controller.php:128](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php:128)

- `CIF-03`  
来源类型：`Code Fact`  
报表输出字段来自 `CustomerContactHistoryReportField`，并在列表展示、API、CSV 下载时按 `field_name` 做映射。  
代码锚点：[customer_contact_history_reports_controller.php:314](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php:314), [customer_contact_history_reports_controller.php:617](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php:617), [customer_contact_history_reports_controller.php:1656](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php:1656)

- `CIF-04`  
来源类型：`Code Fact`  
`target=2` 的当前“最新信息”链路，是“每个客户取 `customer_notes` 最大 `id` 的最新 note，再 left join 到 cdr”，并不是“按 `Cdr.start_date` 取最新”。  
代码锚点：[customer_contact_history_reports_controller.php:704](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php:704)

- `CIF-05`  
来源类型：`Code Fact`  
`/admin/cdr/index` 的「発着信時間」来源于 `cdr.start_date`。  
代码锚点：[cdr_controller.php:690](/Users/palm/bluebean/callcenter/app/controllers/cdr_controller.php:690), [ApplicationResources.properties:1445](/Users/palm/bluebean/callcenter/app/locale/ja/ApplicationResources.properties:1445)

- `CIF-06`  
来源类型：`Code Fact`  
`項目（*必須）` 仅在表形式（`type=1`）显示；集計（`type=2`）使用 X/Y/V 下拉。  
代码锚点：[admin_add.thtml:81](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml:81), [admin_add.thtml:159](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml:159)

- `CIF-07`  
来源类型：`Code Fact`  
`target=2` 的集計查询当前没有 `cdr` join。  
代码锚点：[customer_contact_history_reports_controller.php:823](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php:823)

- `CIF-08`  
来源类型：`Code Fact`  
CSV 有两条独立链路：表形式 `__downloadReportDetail` 与集計 `__downloadMatrixTable`。  
代码锚点：[customer_contact_history_reports_controller.php:1580](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php:1580), [customer_contact_history_reports_controller.php:1486](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php:1486)

- `CIF-09`  
来源类型：`Code Fact`  
CSV 标题取字段 `name`（显示名），不是 `field_name`。  
代码锚点：[customer_contact_history_reports_controller.php:1612](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php:1612)

- `CIF-10`  
来源类型：`Code Fact`  
`api_find_report` 也是基于已配置字段输出。  
代码锚点：[customer_contact_history_reports_controller.php:1791](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php:1791)

- `CIF-11`  
来源类型：`Code Fact`  
顺番默认值来自递增计数，显示顺序受字段数组排列影响。  
代码锚点：[admin_add.thtml:105](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml:105)

- `CIF-12`  
来源类型：`Code Fact`  
既存空值显示并不统一，现状存在空字符串、`N/A`、`（空白）` 等表现。  
代码锚点：[customer_contact_history_reports_controller.php:1666](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php:1666), [customer_contact_history_reports_controller.php:1736](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php:1736), [ApplicationResources.properties:288](/Users/palm/bluebean/callcenter/app/locale/ja/ApplicationResources.properties:288)

- `CIF-13`  
来源类型：`Code Fact`  
`/admin/cdr/index` 默认排序是第 1 列 `id` 降序，不是严格按 `start_date` 降序。  
代码锚点：[cdr_controller.php:61](/Users/palm/bluebean/callcenter/app/controllers/cdr_controller.php:61), [cdr_controller.php:77](/Users/palm/bluebean/callcenter/app/controllers/cdr_controller.php:77), [index.js:38](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/cdr/index.js:38), [sctel.conf:325](/Users/palm/bluebean/callcenter/app/config/sctel.conf:325)

- `CIF-14`  
来源类型：`Code Fact`  
未在该 controller 中发现 Excel / PDF 输出实现，也未发现与该报表直接关联的 batch / cron / 邮件配信链路。  
代码锚点：来源于 Code Investigation Report 第 8 节

与 Round 1 版本的差异：
- 本版所有代码事实均补上 `file:line`。
- 本版将“现有链路如何定义最新”保留为事实陈列，不升格为实现方案。

## 7. Engineering Constraints

- `EC-01`  
来源类型：`Code Fact Derived Constraint`  
表形式配置侧的字段可见性依赖系统字段列表生成机制；因此“新增项目进入表形式配置侧”是独立工程影响面。

- `EC-02`  
来源类型：`Confirmed Requirement + Code Fact`  
`CBR-09` 已确认应沿用既存「顧客最新情報」链路的“最新”定义；而 `CIF-04` 显示该既存链路并非按 `cdr.start_date` 取最新。后续阶段不得将“参考 CDR 页面”替代为业务口径。

- `EC-03`  
来源类型：`Code Fact Derived Constraint`  
集計配置入口与表形式不同；“集計支持”必须单独评估其配置入口、查询链路、展示链路，不能简单视为表形式字段的复用。

- `EC-04`  
来源类型：`Code Fact Derived Constraint`  
`target=2` 的集計查询当前没有 `cdr` join，因此集計支持该项目的影响面大于表形式输出新增一列。

- `EC-05`  
来源类型：`Code Fact Derived Constraint`  
CSV 与 API 不是表形式画面的自然副产物，而是独立输出链路；必须分别校验字段存在、标题表现、值口径、无数据显示。

- `EC-06`  
来源类型：`Confirmed Requirement + Code Fact`  
既存空值表现不统一，但本需求已确认无数据时显示 `-`；后续阶段必须把该 confirmed 行为视为跨输出链路的一致性约束。

- `EC-07`  
来源类型：`Confirmed Requirement + Code Fact`  
`順番` 的确认口径是“包含自定义项目后的全列表最后”，而现状顺序受字段数组排列影响；后续阶段必须保证验收时按“当前实例下全列表最末”判断，而不是按固定序号判断。

- `EC-08`  
来源类型：`Boundary Constraint`  
本卡只能确认需求边界、工程影响面、约束与 Unknowns；不输出 SQL、不输出 patch/diff、不输出具体实现路径、不把候选相关文件写成必须修改文件。

## 8. Out of Scope

- `OOS-01`  
来源类型：`Frozen Requirement Card`  
搜索条件调整不在本次范围内。

- `OOS-02`  
来源类型：`Frozen Requirement Card + Code Fact`  
Excel / PDF 输出不在本次范围内。

- `OOS-03`  
来源类型：`Frozen Requirement Card + Code Fact`  
batch / cron 不在本次范围内。

- `OOS-04`  
来源类型：`Frozen Requirement Card + Code Fact`  
邮件配信内容不在本次范围内。

- `OOS-05`  
来源类型：`Frozen Requirement Card`  
`/admin/cdr/index` 自身不是本次主动修改对象，仅作为参考页面。

- `OOS-06`  
来源类型：`Boundary Control`  
本卡不定义字段命名方案、SQL、查询拼接方式、性能方案、i18n 实现细节、API schema 细节、patch、diff。

- `OOS-07`  
来源类型：`Boundary Control`  
本卡不把 Code Investigation Report 中的“相关文件”升格为“必须修改文件”。

- `OOS-08`  
来源类型：`Frozen Requirement Card + Clarification`  
权限控制机制本身的主动改修不在本卡确认范围；但“是否存在角色级可见性要求”仍保留为 Unknown，不在本章提前拍板。

与 Round 1 版本的差异：
- 本版显式消除了“权限范围已排除”与“权限要求未确认”之间的歧义。

## 9. Engineering Unknowns

### 9.1 业务侧 Unknowns

- `U-B-01`  
来源类型：`Frozen Requirement Card Inherited Unknown`  
多语言文案 / 翻译范围是否仅日文，还是需要覆盖其他语言。

- `U-B-02`  
来源类型：`Frozen Requirement Card Inherited Unknown`  
列宽 / 排序 / 筛选默认行为是否需要对新增项目单独指定。

- `U-B-03`  
来源类型：`Frozen Requirement Card Inherited Unknown`  
是否存在特定角色下该新增项目不可见、不可选或不可输出的业务要求。

- `U-B-04`  
来源类型：`Frozen Requirement Card Inherited Unknown`  
完整菜单操作路径未确认，会影响验收步骤描述与回归用例表达。

### 9.2 工程侧 Unknowns

- `U-E-01`  
来源类型：`Code Fact Derived Unknown`  
集計レポート 配置侧中，`発着信日時（最新）` 应以何种配置类别出现，当前只能确认“必须支持”，不能确认其在 X/Y/V 中的归属。

- `U-E-02`  
来源类型：`Frozen Risk + Code Fact Derived Unknown`  
领导原话中的「発信日付」与用户补充中的「発着信日時（最新）」在“通话方向”和“时间粒度”上存在差异；虽然 `CBR-09` 已确认沿用既存链路口径，但后续阶段仍需先澄清既存链路实际输出表现，不能由实现侧自行解释为某一方向或粒度。

- `U-E-03`  
来源类型：`Code Fact Derived Unknown`  
`api_find_report` 在 `target=2` 场景下，对外字段表达与既存契约如何承接该新增项目，当前材料未确认。

- `U-E-04`  
来源类型：`Code Fact Derived Unknown`  
`-` 的一致性落点尚未确认：是在哪一层被统一处理，还是由不同输出链路分别处理；本卡仅确认最终行为，不拍板处理方式。

与 Round 1 版本的差异：
- 本版明确保留 `U-E-01`，避免把“集計支持”误写成“集計也会在 `項目（*必須）` 里出现”。
- 本版把权限相关问题留在 `U-B-03`，不提前用 Out of Scope 消解。
- 本版继续保留真正 Unknown，不把“可能相关技术细节”硬转成事实。

## 10. Acceptance Mapping

| Frozen AC | 工程验收焦点 | 输出面 | 来源类型 |
|---|---|---|---|
| `AC-001` | `target=顧客最新情報` 时可见新增项目 | `AO-01` | Confirmed |
| `AC-002` | `出力 項目名` 与 `表示名` 均显示 `発着信日時（最新）` | `AO-01` | Confirmed |
| `AC-003` | `順番` 为包含自定义项目后的全列表最后 | `AO-01` | Confirmed + Code Fact Constraint |
| `AC-004` | 勾选并保存后，edit/view 保持已保存状态一致 | `AO-01`, `AO-02` | Confirmed |
| `AC-005` | 表形式レポート查看画面可展示该项目 | `AO-03` | Confirmed |
| `AC-006` | 集計レポート必须支持并展示该项目 | `AO-04`, `AO-05` | Confirmed + Unknown remains on config shape |
| `AC-007` | 有数据时取值遵循既存「顧客最新情報」链路的“最新”定义 | `AO-03`, `AO-05`, `AO-06`, `AO-07`, `AO-08` | Confirmed |
| `AC-008` | 无発着信履歴数据时显示 `-` | `AO-03`, `AO-05`, `AO-06`, `AO-07`, `AO-08` | Confirmed |
| `AC-009` | 表形式 CSV 输出该项目，且口径与画面一致 | `AO-06` | Confirmed |
| `AC-010` | 集計 CSV 输出该项目，且口径与画面一致 | `AO-07` | Confirmed |
| `AC-011` | `api_find_report` 同步输出该项目，且口径与画面一致 | `AO-08` | Confirmed |
| `AC-Regression-001` | 未勾选时既存输出不受影响 | `AO-03`, `AO-05`, `AO-06`, `AO-07`, `AO-08` | Confirmed |
| `AC-Regression-002` | 原有字段的显示名、順番、勾选行为不受影响 | `AO-01`, `AO-02` | Confirmed |
| `AC-Regression-003` | `顧客対応履歴` 侧既有 `発着信時間` 相关行为不受影响 | `AO-03`, `AO-06` | Confirmed + Code Fact |
| `AC-Regression-004` | `/admin/cdr/index` 既有行为不受影响 | `AO-09` | Confirmed |
| `AC-Regression-005` | 既有 CSV / API 字段输出不受影响 | `AO-06`, `AO-07`, `AO-08` | Confirmed |

与 Round 1 版本的差异：
- 本版把 `AC-006` 明确拆成 `AO-04` 与 `AO-05` 两个输出面，提升集計范围表达清晰度。
- 本版把 `AC-011` 单独绑定到 `AO-08`，不再将 API 混入 CSV 验收叙述中。

## 11. Risks / Cautions

- `R-01`  
来源类型：`Frozen Risk + Code Fact`  
“最新”业务口径已确认沿用既存「顧客最新情報」链路，但既存代码事实显示该链路不是按 `cdr.start_date` 取最新。若后续阶段按直觉改写口径，会直接偏离 confirmed requirement。

- `R-02`  
来源类型：`Frozen Risk + Code Fact`  
集計链路当前与表形式链路结构不同，且 `target=2` 集計查询目前没有 `cdr` join；集計影响面显著大于“表形式加一列”。

- `R-03`  
来源类型：`Frozen Risk`  
“順番最后一位”是相对当前实例完整列表而言，而不是某个固定编号；不同租户、自定义字段数量不同，验收必须避免固定下标误判。

- `R-04`  
来源类型：`Frozen Risk + Code Fact`  
无数据显示要求为 `-`，但既存系统空值表现并不统一；若仅在部分链路处理，会出现画面、CSV、API 不一致。

- `R-05`  
来源类型：`Frozen Risk`  
表形式、集計、CSV、API 已全部纳入范围；若后续阶段只完成其中一部分，会形成“范围已确认但交付不完整”的风险。

- `R-06`  
来源类型：`Frozen Risk + Code Fact`  
`/admin/cdr/index` 只是参考页面，且默认排序偏向 `id DESC`；不能把该页面视觉上的“最新”当作本需求的口径依据。

- `R-07`  
来源类型：`Frozen Risk + Business Unknown`  
权限可见性仍未确认；如果后续存在角色差异要求，而前面默认按全员一致可见处理，容易返工。

- `R-08`  
来源类型：`Frozen Ambiguity`  
「発信日付」与「発着信日時（最新）」之间存在方向与粒度双重歧义。本卡不消除该歧义，只确认“沿用既存最新情報链路口径”，其余部分留待后续阶段基于既存行为澄清。

## 12. Handoff to M3 Code-grounded Plan

- `H-01`  
来源类型：`Process Constraint`  
M3 必须以本卡的 `CBR`、`AO`、`EC`、`U-B`、`U-E` 为输入，不得改写 Frozen Requirement Card 的业务需求。

- `H-02`  
来源类型：`Confirmed Requirement Constraint`  
M3 不得把“参考 `/admin/cdr/index` 的 `cdr.start_date`”替换为“本需求的最新口径”；必须先遵守 `CBR-09`。

- `H-03`  
来源类型：`Scope Control`  
M3 需要分别评估 `表形式レポート`、`集計レポート`、`表形式 CSV`、`集計 CSV`、`api_find_report` 五条输出链路，不能将其中任何一条视为自动覆盖。

- `H-04`  
来源类型：`Unknown Control`  
M3 进入具体计划前，应先处理 `U-E-01`、`U-E-02`、`U-E-03`、`U-E-04`；未确认前不得用实现假设替代。

- `H-05`  
来源类型：`Boundary Control`  
M3 不得把 Code Investigation Report 中的候选相关文件升级为“必须修改文件清单”。

- `H-06`  
来源类型：`Boundary Control`  
M3 不得输出 patch / diff / SQL / 具体实现步骤到本卡回写结果中；仅可形成 code-grounded plan 所需的影响点与方案边界。

- `H-07`  
来源类型：`Regression Control`  
M3 需把 `AC-Regression-001` 至 `AC-Regression-005` 作为独立回归面，而不是附带检查项。

- `H-08`  
来源类型：`Business Unknown Carry-over`  
`U-B-01` 至 `U-B-04` 在业务未进一步确认前，M3 不得擅自拍板为“仅日文”“默认排序不变”“所有角色一致可见”或“菜单路径无关”。

与 Round 1 版本的差异：
- 本版 handoff 更明确要求按五条输出链路分别处理。
- 本版把工程 Unknown 前置为 M3 的进入条件之一。
- 本版再次强调“候选相关文件 ≠ 必须修改文件”，提升边界控制。

---

## Candidate: claude

# Engineering Requirement Card Candidate

> **Round 2 改进说明（与 Round 1 Selected Card 的主要差异）**
> - EC-05、EC-06：去除"M3 必须…"等实现方向措辞，改为纯约束性表述，消除"接近实现指引"风险。
> - 第 12 章 H 项：删除方向性动词短语（如"需独立产出"），改为"前提约束"句式，进一步收束 M3 边界。
> - 各章节适度压缩叙述量，降低阅读负担，同时不删除任何 ID 或交叉引用。
> - 新增 CIF-16：补充 `admin_edit.thtml` 与 `admin_view.thtml` 的已知结构事实，完善 AO-02 对应的代码事实依据。
> - U-E-01 下补充"若集計侧不引入该字段，CBR-05 即无法满足"这一约束逻辑，使该 Unknown 的阻塞性更清晰。

---

## 1. Source Inputs

- **Frozen Requirement Card（M1 最终产物）**
  `.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/round-3/12-frozen-requirement-card.md`
  角色：业务需求最高优先级；原样保留，不改写。

- **Code Investigation Report**
  `.cardflow-harness/runs/24174-customer-latest-info-add-send-date/material/02-code-investigation-report-1.md`
  角色：代码事实来源，提供工程约束依据；不作为实现指令。

- **Confirmed Unknowns Before Freeze**
  `.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/round-2/12-confirmed-unknowns.txt`
  角色：M1 已确认事项；其结论必须升格为 confirmed engineering requirements。

- **M1 Summary**
  `.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/M1_SUMMARY.md`
  角色：M1 过程与结论概览；上下文背景。

---

## 2. Requirement Summary

在 `admin/customer_contact_history_reports/add` 当 `target=顧客最新情報` 时，于「項目（*必須）」中追加 `発着信日時（最新）` 项目，使其在表形式レポート / 集計レポート / 表形式 CSV / 集計 CSV / `api_find_report` 五条输出链路中以既存「顧客最新情報」链路的"最新"口径同步呈现；无数据时显示 `-`。

---

## 3. Confirmed Business Requirements

> 来源：Frozen Requirement Card（M1 最终产物）。原样保留，不改写。

- **CBR-01**（来源：Frozen §7）：在 `admin/customer_contact_history_reports/add`、当対象为「顧客最新情報」时，追加 `発着信日時（最新）` 项目。
- **CBR-02**（来源：Frozen §7）：该项目出现在「項目（*必須）」中，并具有 `出力 項目名`、`表示名`、`順番` 配置表现。
- **CBR-03**（来源：Frozen §6 / U-005）：`順番` 位于包含自定义项目后的全列表最后一位。
- **CBR-04**（来源：Frozen §7 / U-001）：表形式レポート 支持 `発着信日時（最新）`。
- **CBR-05**（来源：Frozen §7 / U-001 / U-002）：集計レポート 支持 `発着信日時（最新）`。
- **CBR-06**（来源：Frozen §7 / U-006 / U-008）：表形式 CSV 输出支持 `発着信日時（最新）`。
- **CBR-07**（来源：Frozen §7 / U-008）：集計 CSV 输出支持 `発着信日時（最新）`。
- **CBR-08**（来源：Frozen §7 / U-007）：`api_find_report` 同步输出 `発着信日時（最新）`。
- **CBR-09**（来源：Frozen §6 / U-003）：该项目展示值沿用现有「顧客最新情報」既存链路中的"最新"定义。
- **CBR-10**（来源：Frozen §6 / U-004）：当客户无発着信履歴数据时，该项目显示 `-`。
- **CBR-11**（来源：Frozen §6）：`出力 項目名` 列与 `表示名` 列均显示 `発着信日時（最新）`。
- **CBR-12**（来源：Frozen §7）：与配置页配对的编辑页 / 查看页中，该项目可见性与已保存状态保持一致。

---

## 4. Engineering Scope

> 工程影响范围按"输出链路"维度展开；每项标注来源类型。

### 4.1 表形式レポート
- **配置侧（已确认）**：`target=顧客最新情報` 时，「項目（*必須）」追加 `発着信日時（最新）`，位于"包含自定义项目后的全列表最末"。来源：CBR-01 / CBR-02 / CBR-03。
- **查询侧（来自代码调查）**：表形式 target=2 查询链路涉及 `customer_contacts` + `customer_notes(max id)` + `cdr`（CIF-04）。新字段的查询取值须沿用此链路口径（CBR-09）；具体查询方案不在本卡定义。
- **画面侧（已确认）**：勾选后表形式レポート查看画面能展示该项目（CBR-04）。

### 4.2 集計レポート
- **配置侧（来自代码调查，工程未知）**：「項目（*必須）」仅在 type=1 显示，集計（type=2）使用 X/Y/V 下拉（CIF-06）。业务已确认"集計必须支持"（CBR-05），但该项目在 X/Y/V 中的归属位置属于工程未知（U-E-01）。若集計侧不引入该字段，CBR-05 无法满足，U-E-01 是 M3 前置阻塞项。
- **查询侧（工程约束）**：集計 target=2 SQL 当前无 `cdr` join（CIF-07）。引入该项目对集計查询链路有结构性影响，不得套用表形式方案。
- **画面侧（已确认）**：集計レポート 能展示 `発着信日時（最新）`（CBR-05）。

### 4.3 CSV 输出
- **表形式 CSV（已确认）**：输出 `発着信日時（最新）`，取值口径与画面一致（CBR-06 / CBR-09 / CBR-10）。
- **集計 CSV（已确认）**：输出 `発着信日時（最新）`，取值口径与画面一致（CBR-07 / CBR-09 / CBR-10）。
- **CSV 标题（来自代码调查）**：CSV 标题取字段 `name`（显示名），需与配置侧 `表示名` 严格同源（CIF-09）。

### 4.4 api_find_report
- **已确认**：基于已配置字段输出 CSV 形态结果，需同步包含 `発着信日時（最新）`，取值口径与画面 / CSV 一致（CBR-08 / CBR-09 / CBR-10）。
- **工程约束**：API 对外字段名映射策略需在 M3 前与接口契约方对齐（U-E-03）；本卡不定义 API schema 变更细节。

---

## 5. Affected Outputs

| 编号 | 输出类型 | 来源类型 | 备注 |
|------|----------|----------|------|
| AO-01 | 表形式レポート 配置页（add） | 已确认 | 「項目（*必須）」新增项 |
| AO-02 | 表形式レポート 配置页（edit / view） | 已确认 | 可见性与已保存状态保持一致（CBR-12）；见 CIF-16 |
| AO-03 | 表形式レポート 报表查看画面 | 已确认 | CBR-04 |
| AO-04 | 集計レポート 配置侧 | 已确认（UI 形态待定） | CBR-05；UI 形态见 U-E-01 |
| AO-05 | 集計レポート 报表查看画面 | 已确认 | CBR-05 |
| AO-06 | 表形式 CSV | 已确认 | CBR-06 |
| AO-07 | 集計 CSV | 已确認 | CBR-07 |
| AO-08 | api_find_report | 已确认 | CBR-08 |

---

## 6. Code Investigation Facts

> 来源：Code Investigation Report。仅陈列代码事实，不含推测，不升格为实现指令。

- **CIF-01**：「項目（*必須）」由 controller 内系统字段数组 + 自定义字段数组生成；页面不硬编码具体业务字段。
  `app/controllers/customer_contact_history_reports_controller.php:112`、`app/views/customer_contact_history_reports/admin_add.thtml:81`
- **CIF-02**：`target=2（顧客最新情報）` 的系统字段列表里没有 `Cdr.start_date`；`target=1（顧客対応履歴）` 才有。
  `app/controllers/customer_contact_history_reports_controller.php:198, :128`
- **CIF-03**：报表输出字段来自 `CustomerContactHistoryReportField`，在列表展示 / API / CSV 下载时按 `field_name` 映射取值。
  `app/controllers/customer_contact_history_reports_controller.php:314, :617, :1656`
- **CIF-04**：`target=2` 的"最新信息"当前通过"每个客户取 `customer_notes` 最大 `id`"关联最新 note，再 left join 到 cdr；并非按 `Cdr.start_date` 取最新。
  `app/controllers/customer_contact_history_reports_controller.php:704`
- **CIF-05**：`/admin/cdr/index` 的「発着信時間」对应 `cdr.start_date` 字段。
  `app/controllers/cdr_controller.php:690`、`app/locale/ja/ApplicationResources.properties:1445`
- **CIF-06**：「項目（*必須）」仅在 type=1（表形式）显示；集計（type=2）使用 X/Y/V 下拉。
  `app/views/customer_contact_history_reports/admin_add.thtml:81, :159`
- **CIF-07**：target=2 的集計 SQL 当前无 `cdr` join。
  `app/controllers/customer_contact_history_reports_controller.php:823`
- **CIF-08**：CSV 共两类——表形式 `__downloadReportDetail`、集計 `__downloadMatrixTable`。
  `app/controllers/customer_contact_history_reports_controller.php:1580, :1486`
- **CIF-09**：CSV 标题取字段 `name`（显示名），不是 `field_name`。
  `app/controllers/customer_contact_history_reports_controller.php:1612`
- **CIF-10**：`api_find_report` 基于已配置字段输出 CSV。
  `app/controllers/customer_contact_history_reports_controller.php:1791`
- **CIF-11**：该 controller 未发现 Excel/PDF 输出实现；未发现与 `CustomerContactHistoryReport` 直接关联的 shell/cron；未发现报表直连邮件配信。
  Code Investigation Report §8
- **CIF-12**：无值时多数分支输出空字符串；部分枚举输出 `N/A` 或 `global.blank`（即 `（空白）`）；既存空值显示规则不统一。
  `app/controllers/customer_contact_history_reports_controller.php:1666, :1736`、`app/locale/ja/ApplicationResources.properties:288`
- **CIF-13**：順番默认值由 `$num` 递增，"放最后"依赖字段被追加在数组尾部。
  `app/views/customer_contact_history_reports/admin_add.thtml:105`
- **CIF-14**：`privilege.conf` 中存在 `admin_report_detail_download` 权限项，但 controller 未实现同名 action（历史遗留）。
  `app/config/privilege.conf:121`
- **CIF-15**：`/admin/cdr/index` 默认排序为第 1 列（id）降序；`CDR_SORT=0` 时强制允许该列排序。
  `app/controllers/cdr_controller.php:61, :77`、`app/webroot/js/new_admin/cdr/index.js:38`、`app/config/sctel.conf:325`
- **CIF-16（Round 2 新增）**：`admin_edit.thtml` 与 `admin_view.thtml` 均存在字段渲染区块，与 `admin_add.thtml` 共享相同的字段循环结构；AO-02（edit / view 可见性一致性）对应的代码事实依据。
  `app/views/customer_contact_history_reports/admin_edit.thtml`、`app/views/customer_contact_history_reports/admin_view.thtml`

---

## 7. Engineering Constraints

> 工程约束层。来源类型均标注。不含实现方向指令。

- **EC-01（来自代码调查）**：「項目（*必須）」字段由 `tableSystemFields` 数组生成（CIF-01）。新增项仅在该数组扩展时影响表形式配置侧；集計 X/Y/V 下拉为独立选择入口，不随 `tableSystemFields` 自动扩展（CIF-06）。
- **EC-02（来自代码调查）**：表形式 target=2 的既存"最新"口径基于 `customer_notes.max(id)`（CIF-04），与"按 `cdr.start_date` 取最大值"不等价。本卡已确认采用既存链路口径（CBR-09）；该约束不因实现侧偏好而改变。
- **EC-03（来自代码调查）**：集計 target=2 SQL 当前无 `cdr` join（CIF-07）。集計链路引入 `発着信日時（最新）` 存在结构性查询扩展，影响面大于表形式追加一列，需独立评估。
- **EC-04（来自代码调查）**：CSV 标题取 `name`（显示名）而非 `field_name`（CIF-09）。新增字段的 `name` / `field_name` 命名需一致，以保证画面与 CSV 标题同源。
- **EC-05（来自代码调查）**：既存空值显示规则不统一（空字符串 / `N/A` / `（空白）`，CIF-12）。CBR-10 已确认无数据显示 `-`，与既存任一规则均不同；5 条输出链路上该显示行为的一致性构成验收约束。
- **EC-06（来自代码调查）**：配置页与下游输出之间通过 `field_name` 映射传递（CIF-03）。5 条输出链路（表形式画面、集計画面、表形式 CSV、集計 CSV、api_find_report）上各自均有 `field_name → value` 映射点，新字段需在每个映射点覆盖。
- **EC-07（来自代码调查）**：順番依赖数组追加顺序（CIF-13）。CBR-03"包含自定义项目后的全列表最后"对字段数组追加位置有方向性约束。
- **EC-08（来自代码调查）**：未发现 Excel / PDF / batch / cron / 邮件相关链路（CIF-11），与 Out of Scope 条目一致。

---

## 8. Out of Scope

- **OOS-01（已确认）**：搜索条件调整不在本次范围内。
- **OOS-02（已确认）**：Excel / PDF 输出不在本次范围内（与 CIF-11 一致）。
- **OOS-03（已确认）**：batch / cron 不在本次范围内（与 CIF-11 一致）。
- **OOS-04（已确认）**：邮件配信内容不在本次范围内（与 CIF-11 一致）。
- **OOS-05（已确认）**：`/admin/cdr/index` 不作为本次主动修改对象，仅作参考页面。
- **OOS-06（已确认）**：不主动修改权限控制本身（`privilege.conf` 历史遗留项 `admin_report_detail_download` 不在本次清理范围，CIF-14）。
- **OOS-07（M2 边界）**：本卡不输出 SQL、字段命名方案、patch / diff、性能设计、i18n 实现细节、API schema 变更细节，留待 M3。
- **OOS-08（M2 边界）**：本卡不改写或重新拍板 M1 已确认口径。

---

## 9. Engineering Unknowns

### 9.1 来自 M1 未收敛 Unknown（继承）

- **U-B-01（业务侧）**：多语言文案 / 翻译范围（仅日文 vs. 多语言）。影响：`name` / `表示名` / 提示文案 / CSV 标题翻译覆盖范围。
- **U-B-02（业务侧）**：列宽 / 排序 / 筛选默认行为是否需指定。影响：表形式画面、集計画面、CSV 列定义。
- **U-B-03（业务侧）**：权限可见性是否存在角色级控制。影响：5 条输出链路各自的可见性策略。
- **U-B-04（业务侧）**：完整菜单操作路径未确认。影响：验收步骤描述与回归用例。

### 9.2 工程层 Unknown（来自代码调查衍生）

- **U-E-01（工程未知 / M3 前置阻塞）**：集計レポート 配置侧（X/Y/V 下拉）中，`発着信日時（最新）` 应作为哪类（X 轴 / Y 轴 / V 值，或若干类）出现。CIF-06 表明集計配置形式与表形式独立；CBR-05 仅确认"集計必须支持"，未明确 X/Y/V 归属。**若该 Unknown 未在 M3 前解决，CBR-05 的工程覆盖范围无法确定。**
- **U-E-02（工程未知）**：「発信 / 発着信」与「日付 / 日時」两维口径的最终落地形态。本卡已确认采用既存「顧客最新情報」链路口径（CBR-09），但 CIF-04 所示链路（`customer_notes.max(id)` → cdr）在通话方向（発信 / 着信 / 双向）与时间粒度（日 / 日時）上实际产出何种结果，需以既存链路实际行为为准确认，不由实现侧自行解释。
- **U-E-03（工程未知）**：`api_find_report` 在 target=2 场景下，新增字段的对外字段名（`field_name` 或 `name`）与 CSV 字段映射策略，需与接口契约方对齐后方可确定。
- **U-E-04（工程未知）**：5 条输出链路上 `-` 显示的一致性保障策略（在数据层统一，还是各输出层各自处理），本卡仅约束最终行为须一致（CBR-10），策略由 M3 决定。

---

## 10. Acceptance Mapping

> Frozen 第 10 章业务 AC → 工程验收要点映射。本卡不新增超出 Frozen 的业务 AC。

| Frozen AC | 工程验收要点 | 涉及输出 | 关联 CBR / EC |
|-----------|-------------|----------|----------------|
| AC-001 | `target=顧客最新情報` 时配置页字段列表包含新项 | AO-01 | CBR-01 / EC-01 |
| AC-002 | 配置页 `出力 項目名` 与 `表示名` 列均渲染为 `発着信日時（最新）` | AO-01 | CBR-11 |
| AC-003 | 順番渲染位置在系统字段 + 自定义字段拼接末尾 | AO-01 | CBR-03 / EC-07 |
| AC-004 | 勾选并保存后 `CustomerContactHistoryReportField` 中存在该字段记录；edit / view 页可见性与保存状态一致 | AO-01 / AO-02 | CBR-12 / CIF-16 / EC-06 |
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

> U-B-01 ~ U-B-04 确认后需补充对应 AC，本卡不预置。

---

## 11. Risks / Cautions

- **R-01（来源：Frozen 风险 1 + EC-02）**：既存「顧客最新情報」链路"最新"口径基于 `customer_notes.max(id)`（CIF-04），与一般直觉的"按発着信時間最新"不一致。实现侧不得自行用 `cdr.start_date DESC` 替换；如发现既存链路产生难以理解的结果，需上报业务侧。
- **R-02（来源：Frozen 风险 2 + EC-03）**：集計 target=2 当前无 `cdr` join（CIF-07）。引入新字段会扩展集計查询结构，影响面明显大于表形式；集計链路需独立评估。
- **R-03（来源：Frozen 风险 3 + EC-07）**：「順番最后」依赖追加顺序（CIF-13），自定义项目数量随租户 / 配置变化。验收以"当前实例下全列表最末"为准，不得按固定下标判定。
- **R-04（来源：Frozen 风险 4 + EC-05）**：`-` 显示需在 5 条输出链路保持一致；既存空值规则本身不统一（CIF-12），任一链路漏处理均会产生不一致展示。
- **R-05（来源：Frozen 风险 5 + EC-06）**：5 条输出链路通过 `field_name → value` 映射独立分发（CIF-03），存在某条链路漏接的"做一半"风险；5 处映射缺一不可。
- **R-06（来源：Frozen 风险 6 + CIF-15）**：`/admin/cdr/index` 默认按 `id DESC` 排序，不严格等同于"按 `start_date` 最新"。业务侧若以该参考页视觉顺序对照，可能与既存链路口径产生分歧；以 CBR-09 为准。
- **R-07（来源：Frozen 风险 7 + U-B-03）**：权限可见性未澄清，若 M3 前未确认，按全员一致可见处理存在返工风险。
- **R-08（来源：Frozen 歧义 1 + U-E-02）**：「発信 / 発着信」与「日付 / 日時」两层口径未在 M1 拍板；以既存链路实际行为为准，不由实现侧自行选择字段或方向。
- **R-09（来源：Frozen 歧义 2）**：用户补充原话中的 `cdr参照` 是调查线索而非冻结口径；不以 cdr 表字段直觉作为取值依据。
- **R-10（工程层 + CIF-09 / EC-04）**：CSV 标题取 `name`（显示名）；`name` 与配置侧 `表示名` 须严格同源，否则下载文件标题与画面表示不一致。

---

## 12. Handoff to M3 Code-grounded Plan

> 前提约束清单，供 M3 在进入实现前核对。**非实现方案。**

- **H-01**：第 3 章 CBR 与第 7 章 EC 为 M3 起点，不得改写。
- **H-02**：M3 须严格以 CBR-09 / EC-02 既存「顧客最新情報」链路口径（CIF-04）为准，不得替换为 `cdr.start_date DESC`。
- **H-03**：M3 须将 5 条输出链路（AO-03、AO-05、AO-06、AO-07、AO-08）作为一组验收对象，逐路径核对取值口径与 `-` 显示一致性。
- **H-04**：集計レポート 链路（EC-03）需独立评估其查询结构扩展影响，不得默认沿用表形式实现方式。
- **H-05**：进入实现前须先解决工程层 Unknown：
  - **U-E-01**（集計侧 X/Y/V 归属）— M3 前置阻塞项；
  - **U-E-02**（既存链路在発信/着信、日/日時 上的实际取值表现）；
  - **U-E-03**（`api_find_report` 对外字段名与映射策略）；
  - **U-E-04**（`-` 显示一致性保障策略）。
- **H-06**：U-B-01 ~ U-B-04 一经确认，需补充对应 AC 与处理点；未确认前不得提前拍板。
- **H-07**：Code Investigation Report 中"可能相关文件"不得升格为"必须修改文件"清单；具体修改范围须基于 M3 自行的 code-grounded 评估确定。
- **H-08**：新增字段的 `field_name` 与 `name`（显示名）一致性须覆盖配置页、画面、CSV 标题、API 字段名四处（EC-04）。
- **H-09**：M3 不得在 Plan 阶段输出 patch / diff / 完整 SQL。
- **H-10**：第 8 章 Out of Scope 项不得在 M3 阶段被悄悄纳入。

---

## Candidate: deepseek

# Engineering Requirement Card Candidate

## 1. Source Inputs

- **Frozen Requirement Card (M1 最终产物)**
  路径：`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/round-3/12-frozen-requirement-card.md`
  角色：业务需求最高优先级输入，原样保留，不改写。

- **Code Investigation Report**
  路径：`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/material/02-code-investigation-report-1.md`
  角色：代码事实来源；提供工程约束依据；不作为实现指令。

- **Confirmed Unknowns (M1 已确认事项)**
  路径：`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/round-2/12-confirmed-unknowns.txt`
  角色：M1 阶段已确认事项来源；其确认结论必须升格为 confirmed engineering requirements。

- **M1 总结**
  路径：`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/M1_SUMMARY.md`
  角色：M1 阶段过程与结论概览，作为本卡的上下文背景。

- **Round 1 选定工程需求卡片**
  路径：`m2-engineering-card/round-1/10-selected-engineering-requirement-card.md`
  角色：Round 1 获胜版本 (claude)，作为本次改进的基础。

- **Round 1 决策与评分**
  文件：`m2-engineering-card/round-1/09-decision.md`， `m2-engineering-card/round-1/08-score.json`
  角色：提供 Round 1 的详细反馈与改进方向。

---

## 2. Requirement Summary

在 `admin/customer_contact_history_reports/add` 当 `target=顧客最新情報` 时，于「項目（*必須）」中追加 `発着信日時（最新）` 项目，并使其在表形式レポート / 集計レポート / 表形式 CSV / 集計 CSV / `api_find_report` 五条输出链路中，沿用既存「顧客最新情報」链路的“最新”口径同步呈现，无数据时显示 `-`。

*(此摘要与 Round 1 版本一致，无需修改)*

---

## 3. Confirmed Business Requirements

> **来源：Frozen Requirement Card (M1 最终产物)，原样保留。**
> *为提升可追溯性与 M3 阶段的引用精确度，所有 CBR 条目均显式关联其来源。*

- **CBR-01** (来源：Frozen §7 In Scope)：在 `admin/customer_contact_history_reports/add` 页面、対象为「顧客最新情報」时，追加 `発着信日時（最新）` 项目。
- **CBR-02** (来源：Frozen §7)：该项目出现在 `項目（*必須）` 中，并具有 `出力 項目名`、`表示名`、`順番` 配置表现。
- **CBR-03** (来源：Frozen §6 / Confirmed U-005)：`順番` 位于包含自定义项目后的全列表最后一位。
- **CBR-04** (来源：Frozen §7 / Confirmed U-001)：**表形式レポート** 支持并展示 `発着信日時（最新）`。
- **CBR-05** (来源：Frozen §7 / Confirmed U-001 / U-002)：**集計レポート** 支持并展示 `発着信日時（最新）`。
- **CBR-06** (来源：Frozen §7 / Confirmed U-006 / U-008)：**表形式 CSV** 输出支持 `発着信日時（最新）`。
- **CBR-07** (来源：Frozen §7 / Confirmed U-008)：**集計 CSV** 输出支持 `発着信日時（最新）`。
- **CBR-08** (来源：Frozen §7 / Confirmed U-007)：`api_find_report` 同步输出 `発着信日時（最新）`。
- **CBR-09** (来源：Frozen §6 / Confirmed U-003)：展示的值，**沿用现有「顧客最新情報」既存链路中的“最新”定义**。 (关键口径，不可偏离)
- **CBR-10** (来源：Frozen §6 / Confirmed U-004)：客户无発着信履歴数据时，该项目在**所有输出链路中统一显示 `-`**。
- **CBR-11** (来源：Frozen §6)：在 `出力 項目名` 列与 `表示名` 列均显示为 `発着信日時（最新）`。
- **CBR-12** (来源：Frozen §7)：与该配置页配对的编辑页 / 查看页中，该项目的可见性与已保存状态应保持一致。

*(Round 2 改进说明：为 CBR-04、CBR-05、CBR-06、CBR-07 添加了"支持并展示/输出"的表述以增强明确性；为 CBR-10 添加了"在所有输出链路中统一"的限制，并与 §10 的风险 R-04 呼应。)*

---

## 4. Engineering Scope

> 工程影响范围按“输出链路”维度展开，清晰定义表形式、集計、CSV、API 的影响面。每项均标注来源类型 (已确认 / 来自代码调查 / 推测)。

### 4.1 表形式レポート
- **配置侧** (来源：已确认 CBR-01, CBR-02, CBR-03, CBR-11) : `target=顧客最新情報` 时，「項目（*必須）」需可勾选新增的 `発着信日時（最新）`，`順番` 位于包含自定义项目后的全列表最末，`出力 項目名` 与 `表示名` 均为 `発着信日時（最新）`。
- **数据查询与展示侧** (来源：已确认 CBR-04, CBR-09；来自代码调查 CIF-04) :
    - **要求**：勾选后，表形式レポート查看画面能展示该项目，且取值与“既存链路最新口径”一致。
    - **事实**：代码调查显示既存 target=2 链路为 `customer_contacts` + `customer_notes (max id)` + `cdr` (CIF-04)。
    - **工程影响**：需在此既存查询链路上，为新增字段映射 `cdr` 相关字段的取值。具体 SQL/Join 调整方案不在本卡定义。

### 4.2 集計レポート
- **配置侧** (来源：已确认 CBR-05；来自代码调查 CIF-06) :
    - **要求**：集計レポート 必须支持 `発着信日時（最新）`。
    - **事实**：代码调查显示集計配置使用 X/Y/V 下拉，而非「項目（*必須）」(CIF-06)。
    - **工程未知**：`発着信日時（最新）` 应作为 X 轴、Y 轴、V 值中的哪一类出现，待业务确认 (U-E-01)。
- **数据查询与展示侧** (来源：已确认 CBR-05, CBR-09；来自代码调查 CIF-07) :
    - **要求**：集計レポート 查看画面能展示该项目，取值与“既存链路最新口径”一致。
    - **事实**：代码调查显示当前 target=2 集計 SQL 未 join `cdr` (CIF-07)。
    - **工程影响**：引入 `cdr` 数据将导致集計查询结构发生结构性变更，其影响面和复杂度显著大于表形式レポート，需在 M3 单独评估。

### 4.3 CSV 输出
- **表形式 CSV** (来源：已确认 CBR-06) : 输出 `発着信日時（最新）`，取值口径与画面一致。
- **集計 CSV** (来源：已确认 CBR-07) : 输出 `発着信日時（最新）`，取值口径与画面一致。
- **工程约束** (来自代码调查 CIF-09) : CSV 标题取字段 `name`（显示名），需保证其与配置侧 `表示名` 始终一致。

### 4.4 api_find_report
- **API 输出** (来源：已确认 CBR-08) : 基于已配置字段输出 `発着信日時（最新）`，取值口径与画面/CSV一致。
- **工程影响** (来自代码调查 CIF-10) : 需在 `api_find_report` 对 target=2 的处理逻辑中，为新字段建立映射。API 输出的字段名与映射策略需 M3 明确 (U-E-03)。

*(Round 2 改进说明：集計部分新增对配置侧 X/Y/V UI 形态差异的说明，强化了需求与现有代码事实之间的矛盾点，并将该问题引导至 U-E-01。)*

---

## 5. Affected Outputs

> 受影响的可明确列出的输出面。

| 编号 | 输出类型 | 来源类型 | 备注 |
|------|----------|----------|------|
| AO-01 | 表形式レポート 配置页 (add/edit/view) | 已确认 | 新增项目可见、可勾选、可保存 |
| AO-02 | 表形式レポート 报表查看画面 | 已确认 | CBR-04 |
| AO-03 | 集計レポート 配置侧 (X/Y/V) | 已确认 (具体形态待定) | CBR-05; UI 形态见 U-E-01 |
| AO-04 | 集計レポート 报表查看画面 | 已确认 | CBR-05 |
| AO-05 | 表形式 CSV | 已确认 | CBR-06 |
| AO-06 | 集計 CSV | 已确认 | CBR-07 |
| AO-07 | api_find_report | 已确认 | CBR-08 |

*(Round 2 改进说明：AO-02 与 AO-04 名称优化，以与 AO-01 / AO-03 的“配置页”形成对照。)*

---

## 6. Code Investigation Facts

> 来源：**Code Investigation Report**。仅陈列代码事实，不含推测，不直接升格为实现指令。每个事实均带 `file:line` 锚点。

- **CIF-01**：`admin/.../add` 的「項目（*必須）」由 controller 内系统字段数组 + 自定义字段数组生成；页面不硬编码具体业务字段。
  来源：`app/controllers/customer_contact_history_reports_controller.php:112`， `app/views/customer_contact_history_reports/admin_add.thtml:81`
- **CIF-02**：当前 `target=2 (顧客最新情報)` 的系统字段列表里没有 `Cdr.start_date`；`target=1 (顧客対応履歴)` 才有。
  来源：`app/controllers/customer_contact_history_reports_controller.php:198`， `:128`
- **CIF-03**：报表输出字段来自 `CustomerContactHistoryReportField`（保存的勾选字段），并在列表展示/API/CSV下载时按 `field_name` 映射取值。
  来源：`app/controllers/customer_contact_history_reports_controller.php:314`， `:617`， `:1656`
- **CIF-04**：`target=2` 的“最新信息”当前是通过“每个客户取 `customer_notes` 最大 `id`”来关联最新 note，再 left join 到 cdr，并非按 `Cdr.start_date` 取最新。 **(关键既存口径事实)**
  来源：`app/controllers/customer_contact_history_reports_controller.php:704`
- **CIF-05**：`/admin/cdr/index` 的「発着信時間」就是 `cdr.start_date` 字段。
  来源：`app/controllers/cdr_controller.php:690`， `app/locale/ja/ApplicationResources.properties:1445`
- **CIF-06**：「項目（*必須）」仅在表形式（type=1）显示；集計使用 X/Y/V 下拉。 **(关键 UI 差异事实)**
  来源：`app/views/customer_contact_history_reports/admin_add.thtml:81`， `:159`
- **CIF-07**：target=2 的集計 SQL 当前没有 join `cdr`。 **(关键查询结构事实)**
  来源：`app/controllers/customer_contact_history_reports_controller.php:823`
- **CIF-08**：CSV 共两类：表形式 `__downloadReportDetail`，集計 `__downloadMatrixTable`。
  来源：`app/controllers/customer_contact_history_reports_controller.php:1580`， `:1486`
- **CIF-09**：CSV 标题取字段 `name`（显示名），不是 `field_name`。 **(标题来源事实)**
  来源：`app/controllers/customer_contact_history_reports_controller.php:1612`
- **CIF-10**：`api_find_report` 也基于已配置字段输出 CSV。
  来源：`app/controllers/customer_contact_history_reports_controller.php:1791`
- **CIF-11**：在该 controller 未发现 Excel/PDF/batch/cron/邮件相关实现或调用链。
  来源：Code Investigation Report §8
- **CIF-12**：既存空值显示规则不统一（空字符串 / `N/A` / `（空白）`）。
  来源：`app/controllers/customer_contact_history_reports_controller.php:1666`， `:1736`， `app/locale/ja/ApplicationResources.properties:288`
- **CIF-13**：順番默认值由 `$num` 递增，“放最后”依赖字段被追加在数组尾部。
  来源：`app/views/customer_contact_history_reports/admin_add.thtml:105`
- **CIF-14**：`privilege.conf` 中存在 `admin_report_detail_download` 权限项，但 controller 未实现同名 action。 (历史遗留)
  来源：`app/config/privilege.conf:121`
- **CIF-15**：`/admin/cdr/index` 默认排序为第1列(id)降序，在多数数据下与“最新発着信時間”接近但不严格相等。
  来源：`app/controllers/cdr_controller.php:61`， `:77`， `app/webroot/js/new_admin/cdr/index.js:38`， `app/config/sctel.conf:325`

*(Round 2 改进说明：为关键事实 (CIF-04, CIF-06, CIF-07, CIF-09) 添加了重要性标注，以增强对 M3 的引导。)*

---

## 7. Engineering Constraints

> 基于代码事实与已确认需求的工程约束。

- **EC-01 (来自代码调查 CIF-01, CIF-06)** : 新增字段应出现在 `target=2` 的 `tableSystemFields` 数组中。这将直接影响表形式配置侧和画面，但不会自动影响集計的 X/Y/V 下拉。
- **EC-02 (来自代码调查 CIF-04；上位约束 CBR-09)** : **必须严格复用**既存 `target=2` 的“最新”口径（即 `customer_notes.max(id)` 关联 cdr）。严禁实现者自行用 `cdr.start_date DESC` 或其它方式实现“最新”逻辑。
- **EC-03 (来自代码调查 CIF-07；上位约束 CBR-05)** : 为集計 target=2 链路引入本字段，将强制要求现有集計 SQL (CIF-07) 加入 `cdr` 关联，这是一个**结构性变更**。M3 必须独立评估此变更对查询性能和数据正确性的影响。
- **EC-04 (来自代码调查 CIF-09；上位约束 CBR-11)** : 新增字段的 `name` (显示名，用于 CSV 标题) 必须与其在配置页的 `表示名` (`発着信日時（最新）`) 保持严格一致。`field_name` 用于内部映射 ，命名需在 M3 阶段定稿。
- **EC-05 (来自代码调查 CIF-12；上位约束 CBR-10)** : 新字段无数据时显示 `-`。由于既存空值处理方式混乱 (CIF-12)，M3 阶段必须为 5 条输出链路**分别或统一地设计 `-` 的生成点**，而不能依赖任何既存 fallback 机制。
- **EC-06 (来自代码调查 CIF-03, CIF-10)** : 新增字段需在 `field_name -> value` 映射逻辑处建立分支，此映射点散布在表形式视图、集計视图、表形式CSV、集計CSV、`api_find_report` 五个地方，缺一不可。
- **EC-07 (来自代码调查 CIF-13；上位约束 CBR-03)** : “位于最后”意味着该字段必须在系统字段和自定义字段**都被添加到数组之后**，作为最后一个元素追加。
- **EC-08 (来自代码调查 CIF-11)** : 代码调查未发现与 Excel/PDF/batch/cron/邮件相关的报表输出链路，可作为 Out of Scope 的事实支持。

*(Round 2 改进说明：在 EC-01、EC-03、EC-06 的描述中强化了对集計和 CSV 的独立影响分析，使工程范围边界更清晰。)*

---

## 8. Out of Scope

> 来源：Frozen Requirement Card §8 + 代码调查事实。

- **OOS-01 (已确认)**：搜索条件调整。
- **OOS-02 (已确认，同 CIF-11)**：Excel / PDF 输出。
- **OOS-03 (已确认，同 CIF-11)**：batch / cron。
- **OOS-04 (已确认，同 CIF-11)**：邮件配信内容。
- **OOS-05 (已确认)**：`/admin/cdr/index` 自身的修改。
- **OOS-06 (已确认，同 CIF-14)**：权限控制的主动修改与历史遗留项清理。
- **OOS-07 (M2 边界)**：本卡不包含 SQL / 字段命名 / patch / diff / 性能设计 / i18n 实现细节 / API schema 细节，这些留待 M3。
- **OOS-08 (M2 边界)**：改变或重新诠释 M1 已确认的任何业务口径。

*Round 2 未作修改。*

---

## 9. Engineering Unknowns

> 目前仍待明确的问题，禁止脑补实作。

### 9.1 业务侧 Unknowns（继承自 M1）
- **U-B-01 (业务侧)**：多语言文案/翻译范围（仅日文 vs. 其他语言）。
- **U-B-02 (业务侧)**：列宽/排序/筛选的默认行为。
- **U-B-03 (业务侧)**：权限可见性规则（是否有角色限制）。
- **U-B-04 (业务侧)**：完整菜单操作路径。

### 9.2 工程侧 Unknowns（代码调查衍生）
- **U-E-01 (工程未知)**：集計レポート中，`発着信日時（最新）` 在 X/Y/V 下拉中的归属（属于哪一类，或同时多类可选）。这决定了其在集計配置页的 UI 实现方式。
- **U-E-02 (工程未知)**：Frozen Card 歧义 1 (`発信 vs 発着信`, `日付 vs 日時`) 的最终落地。虽然已确定遵循“既存链路口径”(CBR-09)，但该链路 (CIF-04) 最终实际返回的 `cdr` 数据在通话方向和精度上究竟是哪种组合，需在 M3 基于代码和数据明确，作为实现依据。
- **U-E-03 (工程未知)**：`api_find_report` 新增字段对外的 `field_name` 值和映射策略，需与相关接口消费方确认。
- **U-E-04 (工程未知)**：`-` 显示的最终实现位置（数据库层、后端逻辑层、还是视图层），由 M3 决定以何种方式保证 5 条链路的行为一致性。

*(Round 2 改进说明：所有 Unknowns 保留原样，仅 U-E-01 的描述增加“这决定了其在集計配置页的 UI 实现方式”，强调其重要性。)*

---

## 10. Acceptance Mapping

> 业务验收 (Frozen §10) -> 工程验收要点映射。

| Frozen AC | 工程验收要点 | 涉及输出 | 关联 CBR / EC 约束 |
|-----------|--------------|----------|----------------|
| AC-001 | `target=顧客最新情報` 时配置页字段列表包含新项 `発着信日時（最新）` | AO-01 | CBR-01， EC-01 |
| AC-002 | 配置页 `出力 項目名` 与 `表示名` 均渲染为 `発着信日時（最新）` | AO-01 | CBR-11 |
| AC-003 | 順番渲染位置在系统字段+自定义字段拼接末尾 | AO-01 | CBR-03， EC-07 |
| AC-004 | 勾选并保存后，`CustomerContactHistoryReportField` 中存有该字段 | AO-01 | CBR-12， EC-06 |
| AC-005 | 表形式レポート 查看画面能正确显示该列及数据 | AO-02 | CBR-04， CBR-09， CBR-10， EC-02， EC-06 |
| AC-006 | 集計レポート 能选择（依 U-E-01）并展示该项目 | AO-03, AO-04 | CBR-05， CBR-09， CBR-10， EC-03 |
| AC-007（口径） | 取值必须等于既存链路 `customer_notes.max(id) -> cdr` 查询出的结果 | AO-02, AO-04, AO-05, AO-06, AO-07 | CBR-09， EC-02 |
| AC-008（无数据） | 5 条输出链路必须统一显示 `-`，不能有空串/`N/A`/`（空白）` 等差异 | AO-02, AO-04, AO-05, AO-06, AO-07 | CBR-10， EC-05 |
| AC-009 | 表形式 CSV 包含 `発着信日時（最新）` 列，CBR-09/10 一致 | AO-05 | CBR-06， EC-04， EC-06 |
| AC-010 | 集計 CSV 包含 `発着信日時（最新）` 列，CBR-09/10 一致 | AO-06 | CBR-07， EC-04， EC-06 |
| AC-011 | `api_find_report` 输出 `発着信日時（最新）`，CBR-09/10 一致 | AO-07 | CBR-08， EC-06 |
| AC-Regression-001 | 未勾选时，所有既有输出无任何差异 | All | OOS-08 |
| AC-Regression-002 | 既存「項目（*必須）」原有项目完全不受影响 | AO-01 | EC-01， EC-07 |
| AC-Regression-003 | 「顧客対応履歴」侧(target=1)完全不受影响 | - | CIF-02 |
| AC-Regression-004 | `/admin/cdr/index` 既有行为不变 | - | OOS-05 |
| AC-Regression-005 | 既有 CSV / API 字段输出不变 | AO-05, AO-06, AO-07 | EC-06 |

*Round 2 未作修改。*

---

## 11. Risks / Cautions

- **R-01 (口径漂移风险)** : (来源：Frozen §11 风险1, CIF-04) 既存“最新”口径 (`customer_notes.max(id)`) 非直觉的 `start_date DESC`。M3 实现阶段和测试阶段若有任何偏离此口径的倾向，或发现其返回的结果在业务上难以理解，必须上报，严禁实现者或测试者自行“修正”口径。
- **R-02 (集計链路结构性风险)** : (来源：Frozen §11 风险2, CIF-07) 集計链路引入 `cdr` 表是结构性变更，可能引发查询性能问题或数据范围变化。M3 必须对此进行隔离评估，绝不能复用表形式的实现方案。
- **R-03 (順番验收歧义)** : (来源：Frozen §11 风险3) “最后一位”是动态结果，依赖于租户的自定义字段数量。验收必须以特定租户环境下的实际全列表为准，不能与固定下标比对。
- **R-04 (空值显示“做一半”风险)** : (来源：Frozen §11 风险4/5, CIF-12) `-` 需要在 5 条独立输出链路上实现。若实现分散，极易出现某处遗漏或不一致。AC-008 要求 5 条链路统一显示 `-`，这是验收的关键强制检查点。
- **R-05 (CSV/API 标题与映射遗漏风险)** : (来源：EC-04, EC-06) CSV 标题取 `name`，API 输出有自身的 field mapping。任何一处的遗漏或命名不一致（如 CSV 标题是 `発着信日時`，画面是 `発着信日時（最新）`）都属于缺陷。
- **R-06 (参考页面误导风险)** : (来源：Frozen §11 风险6, CIF-15) `/admin/cdr/index` 视觉上的“最新”不等于业务要求的“最新”。任何人不得将此页面作为测试或验收的“正确答案”来源。
- **R-07 (口径歧义未澄清风险)** : (来源：Frozen §11 歧义1, U-E-02) “発信 vs 発着信”和“日付 vs 日時”仍未拍板，仅确认沿用“既存链路”。M3 阶段**必须**基于代码调查和数据，将此歧义的最终落地形式（链路返回的究竟是哪个方向、哪种粒度的哪个字段值）以文档形式明确，作为开发的唯一依据。
- **R-08 (权限回滚风险)** : (来源：Frozen §11 风险7, U-B-03) 若未来引入角色权限限制，而本次工程按全员可见实现，将产生返工。

*(Round 2 改进说明：R-07 的描述被强化，从“需 M3 明确”变为“必须基于代码和数据明确，并作为唯一依据”，以应对此高风险歧义。)*

---

## 12. Handoff to M3 Code-grounded Plan

> 给下一阶段（M3 Code-grounded Plan）的输入与约束，非实现方案。

- **H-01 (需求基线)**：以本卡 §3 (CBR) 和 §7 (EC) 作为 M3 code-grounded 计划的唯一需求与约束来源，不得偏离。
- **H-02 (核心口径约束)**：M3 计划**必须**以 CIF-04 (既存链路) 和 CBR-09 (沿用口径) 为起点，设计新字段的取值方案。严禁提出任何以 `cdr.start_date` 排序取最新的替代方案。
- **H-03 (全链路验收范围)**：M3 计划必须覆盖 5 条输出链路 (AO-02, AO-04, AO-05, AO-06, AO-07) 的评估与设计，并以此作为一组完整的验收对象，不允许出现偏废。
- **H-04 (集計独立评估)**：M3 计划必须包含对集計レポート链路 (EC-03) 的独立影响分析（查询结构、性能、数据正确性），不能简单附属于表形式レポート的评估。
- **H-05 (工程 Unknown 决议)**：M3 计划启动前，必须先解决或制定方案明确 §9.2 中的所有工程 Unknowns (U-E-01 至 U-E-04)。
- **H-06 (业务 Unknown 处理)**：§9.1 中的业务 Unknowns (U-B-01 至 U-B-04) 一旦确认，M3 需立即将其转化为具体的设计点和验收标准。
- **H-07 (文件清单禁令)**：严禁将代码调查报告中的“相关文件清单”升格为 M3 计划的“必须修改文件清单”。M3 必须基于自身的深入分析确定最终修改范围。
- **H-08 (一致性检查点)**：M3 计划应明确新增字段的 `field_name`、`name` (显示名) 等标识符，并规划它们在配置页、画面渲染、CSV 标题和 API 输出四处的一致性检查点 (Ref: EC-04)。
- **H-09 (计划层级限制)**：M3 Code-grounded Plan 应描述影响点、修改方向和验证方法，**禁止输出具体的 SQL / patch / diff / 完整代码**。
- **H-10 (范围边界)**：严格遵循 §8 Out of Scope，M3 计划不得将 OOS 范围内的项目重新纳入。

*(Round 2 改进说明：H-07 进一步明确，禁止将代码调查报告文件列表直接作为 M3 的修改清单，强调 M3 独立评估的重要性。)*
