# Engineering Requirement Card

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
| AO-07 | 集計 CSV | 已确认 | CBR-07 |
| AO-08 | api_find_report | 已确认 | CBR-08 |
| AO-09 | `/admin/cdr/index` | 参考面 | 仅作参考页面，不在本次主动修改对象内（OOS-05）；见 CIF-05 / CIF-15 |

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
- **CIF-16**：`admin_edit.thtml` 与 `admin_view.thtml` 均存在字段渲染区块，与 `admin_add.thtml` 共享相同的字段循环结构；AO-02（edit / view 可见性一致性）对应的代码事实依据。
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
- **OOS-05（已确认）**：`/admin/cdr/index` 不作为本次主动修改对象，仅作参考页面（参见 AO-09）。
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
| AC-Regression-004 | `/admin/cdr/index` 行为不变 | AO-09 | OOS-05 |
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
- **H-10**：第 8 章 Out of Scope 项不得在 M3 阶段被悄悄纳入；AO-09（`/admin/cdr/index`）仅作参考面，不得升格为修改对象。
