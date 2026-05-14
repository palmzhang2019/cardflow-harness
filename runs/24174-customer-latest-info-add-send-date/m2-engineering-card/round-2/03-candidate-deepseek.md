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
