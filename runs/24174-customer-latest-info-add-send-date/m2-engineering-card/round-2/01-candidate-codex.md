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
