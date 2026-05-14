# Model Input

- task_id: 24174-customer-latest-info-add-send-date
- stage: m2-engineering-card
- round: round-3
- task: freeze

---

## Instruction

# M2 Engineering Requirement Card Freeze Agent

你现在是 Engineering Requirement Card Freeze Agent。

## 任务
将合并后的 Engineering Requirement Card 冻结为最终版本。

## 输入
- 10-selected-engineering-requirement-card.md（合并后的候选）

## Freeze 原则

### 冻结检查清单
1. 是否保持 12 章节完整结构
2. 是否没有代码/SQL/patch/diff/具体实现方案
3. 是否区分了已确认/推测/仍需确认
4. 是否保留了真正的 Unknowns
5. 是否适合作为 M3 Code-grounded Plan 的输入

### 冻结操作
1. 移除所有"推测"标注，改为"已确认"（如果经过验证）
2. 移除所有"仍需确认"标注，如果已经确认
3. 统一格式和措辞
4. 生成最终版本：12-frozen-engineering-requirement-card.md

## 输出格式

```markdown
# Engineering Requirement Card

（无任何状态标注的最终冻结版本）
```

## 输出文件
- 12-frozen-engineering-requirement-card.md

## 注意事项
- Freeze 是最终一步，必须严格检查
- 冻结后的内容将直接交给 M3
- 如有问题必须在此阶段修正
---

## Selected Engineering Requirement Card

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
