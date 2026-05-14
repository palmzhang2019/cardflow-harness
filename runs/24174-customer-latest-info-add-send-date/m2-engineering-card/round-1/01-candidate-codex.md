# Engineering Requirement Card Candidate

## 1. Source Inputs
- `Frozen Requirement Card`：`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/round-3/12-frozen-requirement-card.md`；角色：本卡最高优先级业务基线，业务需求与范围以此为准。`【来源类型：Frozen Requirement Card】`
- `Code Investigation Report`：`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/material/02-code-investigation-report-1.md`；角色：仅提供代码事实、现状链路、约束与风险，不作为实现指令。`【来源类型：Code Investigation Report】`
- `Confirmed Unknowns Before Freeze`：`round-2/12-confirmed-unknowns.txt`（M1 Summary 中引用的路径）；角色：将已确认 Unknown 升格为 confirmed engineering requirements。`【来源类型：Confirmed Unknowns】`
- `M1 Requirement Card Draw Summary`：本轮输入内提供，未单独给出仓库路径；角色：确认 M1 冻结状态、已确认范围与仍保留 Unknown。`【来源类型：M1 Summary】`

## 2. Requirement Summary
- 在「顧客最新情報」报表链路中，新增并贯通 `発着信日時（最新）` 这一可选输出项，使其在表形式レポート、集計レポート、表形式 CSV、集計 CSV、`api_find_report` 中按既有「顧客最新情報」最新口径一致呈现。`【来源类型：Frozen Requirement Card + Confirmed Unknowns】`

## 3. Confirmed Business Requirements
- 已确认：让使用「顧客最新情報」レポート的用户，不必再回到「顧客対応履歴」逐条翻看后人工提取日期。`【来源类型：Frozen Requirement Card】`
- 已确认：希望在当前报表使用链路中，直接看到一个名为 `発着信日時（最新）` 的结果项。`【来源类型：Frozen Requirement Card】`
- 已确认：用户所说"最新"沿用现有「顧客最新情報」既存链路中的"最新"定义（U-003 已确认）。`【来源类型：Frozen Requirement Card】`
- 已确认：在 `admin/customer_contact_history_reports/add` 的 `項目（*必須）` 中出现 `発着信日時（最新）` 一项。`【来源类型：Frozen Requirement Card】`
- 已确认：`発着信日時（最新）` 可被用户勾选。`【来源类型：Frozen Requirement Card】`
- 已确认：在 `出力 項目名` 列与 `表示名` 列均显示 `発着信日時（最新）`。`【来源类型：Frozen Requirement Card】`
- 已确认：`順番` 位于包含自定义项目后的全列表最后（U-005 已确认）。`【来源类型：Frozen Requirement Card】`
- 已确认：勾选后，生成或查看对应 report（表形式レポート / 集計レポート）时，能够展示 `発着信日時（最新）` 这一项目。`【来源类型：Frozen Requirement Card】`
- 已确认：CSV 输出（表形式 CSV / 集計 CSV）中能输出 `発着信日時（最新）`。`【来源类型：Frozen Requirement Card】`
- 已确认：`api_find_report` 同步输出 `発着信日時（最新）`。`【来源类型：Frozen Requirement Card】`
- 已确认：该项目展示的值，沿用现有「顧客最新情報」既存链路中的"最新"定义（U-003 已确认）。`【来源类型：Frozen Requirement Card】`
- 已确认：当客户无発着信履歴数据时，该项目显示为 `-`（U-004 已确认）。`【来源类型：Frozen Requirement Card】`

## 4. Engineering Scope
- 表形式レポート：范围包含「顧客最新情報」对象下该项目的可选配置、保存后可见性、查看画面展示，以及与该配置联动的表形式输出链路；代码调查已确认表形式字段选择与集計字段选择不是同一套入口，不能假定一次接入自动覆盖全部报表形态。`【来源类型：Confirmed engineering requirement = Frozen Requirement Card + Confirmed Unknowns；代码事实 = Code Investigation Report】`
- 集計レポート：范围明确包含 `発着信日時（最新）` 的支持与展示；代码调查已确认集計侧使用独立的 X/Y/V 选择与独立输出链路，且当前 target=2 集計链路与表形式链路并不等价。`【来源类型：Confirmed engineering requirement = Frozen Requirement Card + Confirmed Unknowns；代码事实 = Code Investigation Report】`
- CSV 出力：范围明确包含表形式 CSV 与集計 CSV，两条输出链路都需要输出同一业务项，并保持与画面一致的值口径、无数据显示规则与名称表现。`【来源类型：Confirmed engineering requirement = Frozen Requirement Card + Confirmed Unknowns；代码事实 = Code Investigation Report】`
- `api_find_report`：范围明确包含同步影响；该路径不能只在画面或 CSV 完成后视为已覆盖，需单独视为 in-scope 输出。`【来源类型：Confirmed engineering requirement = Frozen Requirement Card + Confirmed Unknowns；代码事实 = Code Investigation Report】`
- 共通范围边界：本卡只定义影响面、工程约束、验收映射与未知项，不定义 SQL、patch、字段命名方案或具体实现步骤。`【来源类型：Frozen Requirement Card + M1 Summary】`

## 5. Affected Outputs
- `admin/customer_contact_history_reports/add` 中「顧客最新情報」的 `項目（*必須）` 配置表现。`【来源类型：Frozen Requirement Card + Code Investigation Report】`
- 与新增配置对应的编辑页 / 查看页中的已保存字段可见性。`【来源类型：Frozen Requirement Card + Code Investigation Report】`
- 表形式レポート查看画面。`【来源类型：Frozen Requirement Card】`
- 集計レポート查看画面。`【来源类型：Frozen Requirement Card + Confirmed Unknowns】`
- 表形式 CSV。`【来源类型：Frozen Requirement Card + Confirmed Unknowns】`
- 集計 CSV。`【来源类型：Frozen Requirement Card + Confirmed Unknowns】`
- `api_find_report`。`【来源类型：Frozen Requirement Card + Confirmed Unknowns】`

## 6. Code Investigation Facts
- `admin/customer_contact_history_reports/add` 的「項目（*必須）」由 controller 内系统字段数组与自定义字段数组生成，页面本身不硬编码具体业务字段。`【来源类型：代码事实 / Code Investigation Report】`
- 当前 `target=2（顧客最新情報）` 的系统字段列表里没有 `Cdr.start_date`，`target=1（顧客対応履歴）` 才有。`【来源类型：代码事实 / Code Investigation Report】`
- 报表输出字段来自 `CustomerContactHistoryReportField`，列表展示、API、CSV 下载都按保存的 `field_name` 做映射。`【来源类型：代码事实 / Code Investigation Report】`
- `target=2` 当前“最新信息”链路是“每个客户取 `customer_notes` 最大 `id` 的最新 note，再 left join 到 cdr”，并非按 `Cdr.start_date` 取最新。`【来源类型：代码事实 / Code Investigation Report】`
- `/admin/cdr/index` 的「発着信時間」对应 `cdr.start_date`。`【来源类型：代码事实 / Code Investigation Report】`
- `/admin/cdr/index` 默认排序是第 1 列 `id DESC`，并不等同于严格的 `start_date DESC`。`【来源类型：代码事实 / Code Investigation Report】`
- `項目（*必須）` 仅在表形式（type=1）显示；集計使用 X/Y/V 下拉，且 target=2 的集計 SQL 当前没有 join `cdr`。`【来源类型：代码事实 / Code Investigation Report】`
- CSV 现有两条独立输出链路：表形式 `__downloadReportDetail`、集計 `__downloadMatrixTable`；`api_find_report` 也是基于已配置字段输出。`【来源类型：代码事实 / Code Investigation Report】`
- CSV 标题取字段 `name`（显示名），无值时现有不同路径存在空字符串、`N/A`、`global.blank` 等不同表现。`【来源类型：代码事实 / Code Investigation Report】`

## 7. Engineering Constraints
- 「最新」口径已被业务确认必须沿用现有「顧客最新情報」既存链路，因此工程上不能把该字段擅自解释为“按 `cdr.start_date` 最大值取最新”。`【来源类型：Confirmed engineering requirement = Frozen Requirement Card + Confirmed Unknowns；代码事实 = Code Investigation Report】`
- 表形式与集計不是同一选择入口、不是同一输出链路，因此工程评估必须把两者视为独立影响面，不能以“表形式已覆盖”替代“集計已覆盖”。`【来源类型：Code Investigation Report + Confirmed Unknowns】`
- 表形式 CSV、集計 CSV、`api_find_report` 是分散链路，工程上必须保证同一业务项在多输出路径中的值口径、无数据显示规则、显示名保持一致。`【来源类型：Frozen Requirement Card + Code Investigation Report】`
- `順番` 的“最后一位”已被确认是“包含自定义项目后的全列表最后”，因此工程验收必须按当前实例的完整列表语义判断，而不是按固定下标判断。`【来源类型：Confirmed Unknowns + Frozen Requirement Card】`
- 当前字段表是由系统字段数组顺序与自定义字段数组共同渲染，工程上新增业务项必须适配该既有生成模型。`【来源类型：Code Investigation Report】`
- 本阶段禁止把“代码调查中出现的可能相关文件”升级为“必须修改文件”，也禁止把调查事实直接写成实现方案。`【来源类型：Frozen Requirement Card + M1 Summary】`

## 8. Out of Scope
- 已确认：搜索条件调整不在本次范围内。`【来源类型：Frozen Requirement Card】`
- 已确认：Excel / PDF 输出不在本次范围内。`【来源类型：Frozen Requirement Card】`
- 已确认：batch / cron 不在本次范围内。`【来源类型：Frozen Requirement Card】`
- 已确认：邮件配信内容不在本次范围内。`【来源类型：Frozen Requirement Card】`
- 已确认：本卡仅定义需求与验收边界，不定义实现方式。`【来源类型：Frozen Requirement Card】`

## 9. Engineering Unknowns
- 多语言文案 / 翻译范围：本次是否仅日文即可，还是需要覆盖其他语言。`【来源类型：仍需确认 / Frozen Requirement Card + Confirmed Unknowns + M1 Summary】`
- 列宽 / 排序 / 筛选默认行为：新增项目在报表查看页面与 CSV 输出中是否需要指定默认行为，还是沿用系统默认。`【来源类型：仍需确认 / Frozen Requirement Card + Confirmed Unknowns + M1 Summary】`
- 权限可见性：是否存在特定角色下该新增项目不可见或不可选的业务要求。`【来源类型：仍需确认 / Frozen Requirement Card + Confirmed Unknowns + M1 Summary】`
- 完整菜单操作路径：虽不改变需求本身，但仍影响验收步骤与交付说明。`【来源类型：仍需确认 / Frozen Requirement Card + Confirmed Unknowns + M1 Summary】`

## 10. Acceptance Mapping
- AC-001 至 AC-004：工程验收需确认 target=`顧客最新情報` 时，新增项在配置页可见、名称正确、位于包含自定义项目后的全列表最后、可勾选并可保存。`【来源类型：Frozen Requirement Card + Confirmed Unknowns】`
- AC-005 至 AC-006：工程验收需分别确认表形式レポート与集計レポート都能展示该项目，且不能用单一路径通过来替代另一条路径。`【来源类型：Frozen Requirement Card + Confirmed Unknowns + Code Investigation Report】`
- AC-007 至 AC-008：工程验收需确认该项目的值遵循既有「顧客最新情報」最新口径，无発着信履歴数据时统一显示 `-`。`【来源类型：Frozen Requirement Card + Confirmed Unknowns】`
- AC-009 至 AC-010：工程验收需分别确认表形式 CSV 与集計 CSV 输出该项目，且值口径与画面一致。`【来源类型：Frozen Requirement Card + Confirmed Unknowns】`
- AC-011：工程验收需单独确认 `api_find_report` 同步输出该项目，且值口径与画面 / CSV 一致。`【来源类型：Frozen Requirement Card + Confirmed Unknowns】`
- AC-Regression-001 至 AC-Regression-005：工程验收需确认未勾选该项时既存项目不受影响、既存「顧客対応履歴」侧行为不受影响、`/admin/cdr/index` 既有行为不受影响、既存 CSV / API 字段不受影响。`【来源类型：Frozen Requirement Card】`

## 11. Risks / Cautions
- 风险：代码事实显示 target=2 现有“最新”链路是 latest note(max id) 后关联 cdr，而不是 `cdr.start_date` 最大值；若工程实现误把 `/admin/cdr/index` 或 `cdr.start_date` 视觉理解当作真值，会与已确认业务口径冲突。`【来源类型：Code Investigation Report + Confirmed Unknowns】`
- 风险：集計レポート已被确认纳入范围，但其现有选择方式与数据链路独立于表形式，影响面明显大于“仅加一个表形式字段”。`【来源类型：Confirmed Unknowns + Code Investigation Report】`
- 风险：表形式 CSV、集計 CSV、`api_find_report` 与画面是分散链路，存在“只做一半”而导致输出不一致的风险。`【来源类型：Frozen Requirement Card + Code Investigation Report】`
- 风险：当前无值表现存在空字符串、`N/A`、`global.blank` 等差异，而业务已确认无数据显示为 `-`；若各链路不统一，会直接造成验收失败。`【来源类型：Confirmed Unknowns + Code Investigation Report】`
- 注意：`順番` 的验收基准是“当前实例下包含自定义项目后的完整列表最末位”，不同租户 / 配置的自定义项目数量不同，不应把它误读成某个固定序号。`【来源类型：Frozen Requirement Card + Confirmed Unknowns】`
- 注意：领导原话中的「発信日付」与用户补充中的「発着信日時（最新）」在“発信/発着信”与“日付/日時”两个维度上仍存在表述差异；本卡不能把该歧义擅自消解为单一工程事实。`【来源类型：Frozen Requirement Card】`
- 注意：`/admin/cdr/index` 在本轮材料中是参考页面与参考字段来源，不应被自动升级为本次必须修改对象。`【来源类型：Frozen Requirement Card + Code Investigation Report】`

## 12. Handoff to M3 Code-grounded Plan
- M3 应继续以 Frozen Requirement Card 为业务基线，不得把 `発着信日時（最新）` 重新解释为“按 `Cdr.start_date` 取最大值”。`【来源类型：Frozen Requirement Card + Confirmed Unknowns】`
- M3 应把表形式レポート、集計レポート、表形式 CSV、集計 CSV、`api_find_report` 视为需要分别落地核对的工程影响面，不得默认某一路径完成后其他路径自动覆盖。`【来源类型：Frozen Requirement Card + Code Investigation Report】`
- M3 应把代码调查中的 controller / view / locale / API 链路仅视为候选调查面，而不是预先锁定的必须修改文件集合。`【来源类型：Code Investigation Report + Frozen Requirement Card】`
- M3 应显式保留并追踪仍未确认的四项 Unknown：多语言文案、列宽 / 排序 / 筛选默认行为、权限可见性、完整菜单操作路径。`【来源类型：Confirmed Unknowns + M1 Summary】`
- M3 在进入实现前，应继续注意「発信日付」与「発着信日時（最新）」之间的方向与粒度歧义，不得由实现侧自行拍板。`【来源类型：Frozen Requirement Card】`
- M3 的职责是做 code-grounded 评估与方案化，不是回写业务需求；本卡未确认的事项在进入实现前仍需保持 Unknown 状态。`【来源类型：Frozen Requirement Card + M1 Summary】`
