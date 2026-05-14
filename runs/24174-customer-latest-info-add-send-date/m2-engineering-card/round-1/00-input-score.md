# Model Input

- task_id: 24174-customer-latest-info-add-send-date
- stage: m2-engineering-card
- round: round-1
- task: scoring

---

## Instruction

# M2 Engineering Requirement Card Candidate Scorer

你现在是 Engineering Requirement Card Scoring Agent。

## 任务
基于比较报告，对三个候选 Engineering Requirement Card 进行评分。

## 输入
- 07-comparison.md（比较报告）
- 01-candidate-codex.md
- 02-candidate-claude.md
- 03-candidate-deepseek.md

## 评分维度（固定 6 项）

### 1. requirement_alignment（权重：20%）
是否严格继承 Frozen Requirement Card 的业务需求，不改写。

评分标准：
- 5：完全保持业务需求原样，无任何改写
- 4：基本保持，有微小措辞调整但不影响语义
- 3：有一定偏差但核心需求保留
- 2：有明显改写，改变了业务语义
- 1：完全偏离，擅自改写业务需求

### 2. code_fact_grounding（权重：20%）
是否正确使用 Code Investigation Report 的代码事实，不把推测升格为事实。

评分标准：
- 5：完全基于代码事实，推测与事实严格区分
- 4：基本基于事实，有少量未标注的推测
- 3：事实与推测混淆，但无错误升格
- 2：存在将推测升格为事实的情况
- 1：大量推测被当作事实使用

### 3. engineering_scope_clarity（权重：20%）
是否清楚表达工程影响范围。

评分标准：
- 5：四个影响领域（表形式、集計、CSV、api_find_report）全部清晰说明
- 4：三个领域清晰，一个领域模糊
- 3：两个领域清晰，其余模糊
- 2：一个领域清晰，其余不明确
- 1：未明确工程影响范围

### 4. boundary_control（权重：15%）
是否避免进入 Plan / SQL / patch / diff / 具体实现方案。

评分标准：
- 5：完全遵守约束，无任何违规
- 4：有一个小违规（如提及但不详细）
- 3：有明显违规（如写了 SQL 但标记为示例）
- 2：有多处违规
- 1：大量违规（写了代码、SQL、具体方案）

### 5. unknowns_quality（权重：15%）
是否保留真正需要确认的工程 Unknowns。

评分标准：
- 5：未知事项全部保留，无脑补，无重复 M1 内容
- 4：有一个未知被错误消除
- 3：有多个未知被消除
- 2：大量消除或重复 M1 已知内容
- 1：几乎没有真正的未知

### 6. m3_handoff_readiness（权重：10%）
是否适合作为 M3 Code-grounded Plan 的输入。

评分标准：
- 5：可直接作为 M3 输入，结构清晰
- 4：有小问题但基本可用
- 3：有结构性问题需要修正
- 2：有严重问题导致不可用
- 1：完全不可用

## 输出格式

```json
{
  "scores": {
    "codex": {
      "requirement_alignment": 0,
      "code_fact_grounding": 0,
      "engineering_scope_clarity": 0,
      "boundary_control": 0,
      "unknowns_quality": 0,
      "m3_handoff_readiness": 0,
      "total_weighted_score": 0.0
    },
    "claude": {
      "requirement_alignment": 0,
      "code_fact_grounding": 0,
      "engineering_scope_clarity": 0,
      "boundary_control": 0,
      "unknowns_quality": 0,
      "m3_handoff_readiness": 0,
      "total_weighted_score": 0.0
    },
    "deepseek": {
      "requirement_alignment": 0,
      "code_fact_grounding": 0,
      "engineering_scope_clarity": 0,
      "boundary_control": 0,
      "unknowns_quality": 0,
      "m3_handoff_readiness": 0,
      "total_weighted_score": 0.0
    }
  },
  "recommended_winner": "codex|claude|deepseek",
  "reasoning": "选择理由说明"
}
```

## 计算公式

```
total_weighted_score =
  requirement_alignment * 0.20 +
  code_fact_grounding * 0.20 +
  engineering_scope_clarity * 0.20 +
  boundary_control * 0.15 +
  unknowns_quality * 0.15 +
  m3_handoff_readiness * 0.10
```

## 注意事项
- 必须给出每个维度的具体分数
- 必须计算加权总分
- 必须明确推荐胜者及其理由
- 如有违规内容必须扣分
---

## Comparison Report

# Engineering Requirement Card Comparison Report

## Candidates Overview

- **codex**：结构纪律性最强，所有条目都明确标注「来源类型」，严格避免实现细节、SQL、patch；缺点是缺少 ID 体系，AC 映射较粗，对 Code Investigation Facts 的引用没有具体文件行号。
- **claude**：信息密度最高，建立完整的 ID 体系（CBR / EC / AO / CIF / U-B / U-E / R / H），每条 Code Investigation Fact 都带 `file:line` 出处；明确区分"业务侧 Unknown"与"工程层 Unknown"；唯一缺点是篇幅较长。
- **deepseek**：覆盖维度齐全且有 AC 映射表；但存在数处边界滑移——AC-007 将"既存链路"具体化为 `customer_notes.id 最大记录关联 cdr.start_date`，把推测当事实；§7 "多语言准备"做了未确认的实现承诺；引用了 `U-009/U-010/U-011/U-012` 等无源 ID。

## Dimension Scores

| Dimension | codex | claude | deepseek |
|-----------|-------|--------|----------|
| requirement_alignment | 9 | 9 | 7 |
| code_fact_grounding | 8 | 10 | 7 |
| engineering_scope_clarity | 8 | 9 | 7 |
| boundary_control | 9 | 9 | 6 |
| unknowns_quality | 8 | 10 | 7 |
| m3_handoff_readiness | 8 | 10 | 7 |

## Strengths and Weaknesses

### codex
**Strengths**
- 每个 bullet 都带「来源类型」徽标，可追溯性高。
- 第 11 章 Risks 把"発信/発着信、日付/日時"歧义明确保留，不擅自消解。
- 第 12 章明确告诉 M3：代码调查中的文件只是"候选调查面"，不是"必须修改文件清单"——边界感强。
- 未出现任何 SQL / patch / 具体字段命名方案。

**Weaknesses**
- 没有 ID 体系，AC 与 Constraint / Output 之间的映射是叙述性的，M3 引用时颗粒度不够。
- Code Investigation Facts 没有具体文件行号，仅描述事实陈述。
- 未细分"业务 Unknown vs 工程 Unknown"，4 项 Unknown 全部归为"仍需确认"。

### claude
**Strengths**
- 全卡建立 CBR-01…CBR-12、EC-01…EC-08、AO-01…AO-08、CIF-01…CIF-15、U-B / U-E 双层 Unknown、R-01…R-10、H-01…H-10 的 ID 体系，AC Mapping 表交叉引用最完整。
- 每条 Code Investigation Fact 都带 `file:line`，对应代码调查报告位置精确。
- 明确区分"业务侧 Unknown"（继承 M1）与"工程层 Unknown"（代码调查衍生），其中 U-E-01（X/Y/V 归属）、U-E-04（`-` 显示统一实现位置）是只有 claude 主动识别出来的工程未知。
- §12 Handoff 列出 10 条明确约束，包括"M3 不得将'可能相关文件'升格为必须修改文件清单"、"M3 不得输出 patch/diff/完整 SQL"。

**Weaknesses**
- 篇幅最长，阅读成本相对高。
- 个别条目（如 EC-05 关于 `-` 显示）已经接近"实现指引"边缘，但仍保持在"约束"而非"方案"层面，未越界。

### deepseek
**Strengths**
- 输出结构齐全，AC Mapping 用表格呈现，便于阅读。
- 把"発信日付 vs 発着信日時（最新）"歧义单独列入 Unknowns。
- 风险章节继承了 Frozen Card 的全部风险项。

**Weaknesses（含明确边界违规）**
- **边界违规**：AC-007 写"字段值等于基于 `customer_notes.id` 最大记录关联而来的 `cdr.start_date`（或其他链路口径）"——这把代码调查中的事实推测**升格为业务验收事实**。Frozen Card 只确认"沿用既存链路口径"，并未确认该口径最终落到 `cdr.start_date`。这是 M2 阶段应避免的"推测升格为事实"。
- **边界违规**：§7 "**多语言准备**"写"新增字段的 `表示名` 至少需要提供日文文案"——M1 已把多语言范围列为 Unknown，本卡擅自给出"至少日文"的实现承诺。
- **边界违规**：§12 出现"M3 需详细描述如何复用现有「顧客最新情報」既存链路中的'最新'查询逻辑，并将结果映射到新字段"——已接近规定实现方向。
- **追溯性问题**：引用 `U-009 / U-010 / U-011 / U-012` 这类 ID 在 M1 Confirmed Unknowns 中并不存在，是凭空构造的引用。
- 未细分业务 Unknown 与工程 Unknown，对集計侧 X/Y/V 归属这一关键工程未知未明确识别。

## Recommended Priority

1. **claude** — 推荐作为 M3 主输入。ID 体系完整、代码事实带文件行号、业务/工程 Unknown 双层分离、Handoff 约束明确，是最适合 M3 Code-grounded Plan 直接引用的版本。
2. **codex** — 推荐作为 M3 边界参考。纪律性与可追溯性强、零越界，但 ID 颗粒度不足；建议在采用 claude 主卡的同时，用 codex 的"来源类型徽标"机制做边界审查。
3. **deepseek** — 不推荐直接作为 M3 输入。AC-007 / §7 多语言 / §12 措辞均存在"推测升格为事实"或"指定实现方向"的边界滑移，且引用了不存在的 Unknown ID，需修订后方可使用。

---

## Candidate: codex

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

---

## Candidate: claude

# Engineering Requirement Card Candidate

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
  路径：`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m1-requirement-card/M1-summary.md`
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

## Candidate: deepseek

# Engineering Requirement Card Candidate

## 1. Source Inputs
- **Frozen Requirement Card (M1 Final Output)**：最高优先级输入，提供已确认的业务需求、验收标准、范围与未知事项。
  - 来源：`round-3/12-frozen-requirement-card.md`
- **Code Investigation Report**：提供代码事实，不作为实现指令。
  - 来源：`material/02-code-investigation-report-1.md`
- **Confirmed Unknowns (M1 Round 2)**：将 M1 阶段已确认事项升格为工程需求。
  - 来源：`round-2/12-confirmed-unknowns.txt`
- **M1 Summary**：提供 M1 过程上下文及最终产出信息。
  - 来源：`m1-requirement-card/round-3/12-frozen-requirement-card.md` 的总结

## 2. Requirement Summary
在 `顧客最新情報` 报表配置及所有输出通道（表形式レポート、集計レポート、表形式 CSV、集計 CSV、`api_find_report`）中追加一个可选字段「発着信日時（最新）」，并沿用现有「顧客最新情報」链路中的“最新”定义展示对应日期时间，免除用户人工从全履历中提取最新発信日付。

## 3. Confirmed Business Requirements
以下内容直接来源于 Frozen Requirement Card，业务需求原样保留：

- 在 `admin/customer_contact_history_reports/add` 页面，当対象为「顧客最新情報」时，`項目（*必須）` 中追加可选项目 `発着信日時（最新）`。  
  - 来源：FRC §4、§7
- 该项目在 `出力 項目名` 列与 `表示名` 列均显示 `発着信日時（最新）`；`順番` 位于包含自定义项目后的全列表最后。  
  - 来源：FRC §7（已确认）、U-005（已确认）
- 勾选该项目后，表形式レポート、集計レポート均能展示 `発着信日時（最新）`。  
  - 来源：FRC §7、U-001、U-002
- CSV 输出（表形式 CSV、集計 CSV）中能输出 `発着信日時（最新）`。  
  - 来源：FRC §7、U-006、U-008
- `api_find_report` 同步输出 `発着信日時（最新）`。  
  - 来源：FRC §7、U-007
- 「最新」的判定口径：沿用现有「顧客最新情報」既存链路中的“最新”定义。  
  - 来源：FRC §7、U-003
- 当客户无発着信履歴数据时，该项目显示 `-`。  
  - 来源：FRC §7、U-004
- 搜索条件、Excel/PDF 输出、batch/cron、邮件配信不在本次范围。  
  - 来源：FRC §8

## 4. Engineering Scope
本次工程范围明确涉及以下系统输出通道，均需对新增字段进行处理：

- **表形式レポート**
  - 影响：配置页面 `項目（*必須）` 的表形式系统字段列表需追加 `発着信日時（最新）` 字段定义；报表详情页面（含 DataTables JSON 数据）需支持该字段的输出；CSV 下载需包含该栏位。
  - 来源：CI §2, §5, §7, §8；FRC §7

- **集計レポート**
  - 影响：当前集計レポート的配置方式（X/Y/V 下拉）与表形式不同，但业务要求其最终输出支持该字段。现有代码中 target=2 的集計查询未 join cdr 表，引入此字段会影响 SQL 与数据映射逻辑。需在报表结果生成及 CSV 输出中增加该字段的处理。
  - 来源：CI §7；U-001, U-002；FRC §7

- **CSV 出力**
  - 影响：包含表形式 CSV (`__downloadReportDetail`) 和集計 CSV (`__downloadMatrixTable`)。字段映射、标题列名（显示名）与数据填充均需处理。
  - 来源：CI §8；FRC §7；U-006, U-008

- **api_find_report**
  - 影响：该 API 基于已配置的报表字段输出 CSV，新增字段后需确保 API 响应中包含该数据列，且取值口径与其他通道一致。
  - 来源：CI §8；U-007；FRC §7

此外，配置页面的新建 (`admin_add`) 和编辑 (`admin_edit`) 功能需支持该字段的展示、勾选与保存，并联动对应查看 (`admin_view`) 页面的状态一致性。  

- 来源：CI §2, §4, §5；FRC §7

## 5. Affected Outputs
- 表形式レポート画面（HTML / DataTables JSON）
- 集計レポート画面（Matrix 视图）
- 表形式 CSV
- 集計 CSV
- `api_find_report` 接口响应

## 6. Code Investigation Facts
以下事实均来源于代码调查报告，不含推测：

1. 配置页 `項目（*必須）` 的表形式（type=1）字段列表由 `__setFormData()` 按 `target` 分支构建；`target=1`（顧客対応履歴）包含 `Cdr.start_date`，但 `target=2`（顧客最新情報）的列表中没有 `Cdr.start_date`。  
   - 来源：CI §1, §4

2. 字段保存后存入 `customer_contact_history_report_fields` 表，输出时通过 `field_name` 映射取值。  
   - 来源：CI §5

3. 当前 `target=2` 的“顧客最新情報”查询逻辑是：按每个客户取 `customer_notes` 最大 `id` 关联最新 note，再 left join `cdr` 表，并不是按 `Cdr.start_date` 取最大。  
   - 来源：CI §1, §5

4. `/admin/cdr/index` 页面的「発着信時間」即 `cdr.start_date`，默认排序为 id 降序，不完全等价于按 `start_date` 降序。  
   - 来源：CI §6

5. 集計レポート的配置方式为 X/Y/V 下拉，并非表形式的字段勾选列表；其 target=2 的集計 SQL 当前未 join `cdr` 表。  
   - 来源：CI §7

6. CSV 标题取自字段 `name`（显示名），部分无值情况输出空字符串、`N/A` 或 `global.blank`，并非统一为 `-`。  
   - 来源：CI §5

7. `api_find_report` 基于已配置字段输出 CSV，调用链相同控制器。  
   - 来源：CI §8

8. 权限配置文件 `privilege.conf` 中虽有 `admin_report_detail_download` 项，但控制器未实现同名 action。  
   - 来源：CI §8

## 7. Engineering Constraints
基于代码调查和已确认业务口径，存在以下必须遵守的工程约束：

- **“最新”判定口径已锁定**：必须沿用现有「顧客最新情報」既存链路的“最新”逻辑（即基于 `customer_notes` 最大 id 关联 cdr），不允许自行改为 `Cdr.start_date` 最大值的取法。  
  - 来源：U-003；CI §1, §5

- **集計レポート的影响面**：target=2 的集計 SQL 未 join cdr，若需在此通道展示 `発着信日時（最新）`，必须扩展数据查询，但这可能牵涉性能及现有数据范围，必须单独评估，不可简单复用表形式的映射。  
  - 来源：CI §7

- **无数据时的显示一致性**：所有输出通道（画面、CSV、API）必须统一显示为 `-`，但现有代码中不同路径有空串/`(空白)`/`N/A` 的差异，需要统一适配。  
  - 来源：CI §5；U-004

- **順番的计算**：`順番` 是基于字段数组追加位置决定，并非固定下标；新增字段需放在系统字段数组末尾，但必须保证在自定义字段之后（即全列表最后）。  
  - 来源：CI §4, §5；U-005

- **多语言准备**：现有文案通过 `ApplicationResources.properties` 管理；新增字段的 `表示名` 至少需要提供日文文案，但多语言覆盖范围尚未确认。  
  - 来源：CI §2, §9；Frozen Card §9, Unknowns

- **权限未变更**：本次不主动修改权限控制，且代码中未发现关联权限实际生效的 action，暂不引入新的权限项。  
  - 来源：FRC §8；CI §8

## 8. Out of Scope
以下事项明确不在本次工程范围内：

- 搜索条件调整  
- Excel / PDF 输出  
- batch / cron 处理  
- 邮件配信内容  
- `/admin/cdr/index` 页面的修改  
- 权限控制本身的改动  
- 多语言、列宽/排序/筛选默认行为、权限可见性的最终确定（这些仍为 Unknowns，待后续确认后纳入）  
  - 来源：FRC §8, §9

## 9. Engineering Unknowns
以下事项仍需确认，不可在当前阶段脑补或实施：

1. **多语言文案 / 翻译范围**：是否仅需日文，还是必须覆盖系统支持的其他语言。  
   - 来源：FRC §9；U-009

2. **列宽 / 排序 / 筛选默认行为**：新增字段在报表查看页面、CSV 文件中是否需要特定的列宽、默认排序或筛选设置，还是沿用系统默认。  
   - 来源：FRC §9；U-010

3. **权限可见性**：是否存在特定角色下该新增项目不可见或不可选的业务规则。  
   - 来源：FRC §9；U-011

4. **完整菜单操作路径**：用户验收时精确的导航路径未确认，虽不影响核心需求，但影响测试用例编写。  
   - 来源：FRC §9；U-012

5. **“発信日付” vs “発着信日時（最新）”歧义**：领导原话的“発信日付”与用户补充的“発着信日時（最新）”存在通话方向（発信/発着信）和时间粒度（日付/日時）的差异。本卡阶段已确认“最新”沿用既存链路，但该链路最终输出的具体方向与粒度仍需后续结合代码实现澄清，不可由工程侧自行决定。  
   - 来源：FRC §11 歧义1；本卡 §7 注意事项

## 10. Acceptance Mapping
以下将业务验收标准（Frozen AC）映射为工程验收关注点：

| 业务 AC | 工程验收要点 | 来源 |
|---------|-------------|------|
| AC-001：配置页可见新增项目 | 表形式 `tableSystemFields` 数组中包含 `発着信日時（最新）` ，`target=2` 时正确渲染 | FRC AC-001 |
| AC-002：出力项目名/表示名正确 | 字段定义中 `name` 与 `label` 均显示为 `発着信日時（最新）` ；多语言资源键正确映射 | FRC AC-002 |
| AC-003：順番位于最后 | 字段追加顺序使 `順番` 值大于所有其他系统及自定义字段；编辑和新建页一致 | FRC AC-003, U-005 |
| AC-004：可勾选并保存 | 表单提交正确，字段关系写入 `customer_contact_history_report_fields` | FRC AC-004 |
| AC-005：表形式画面展示 | 表形式报表详情页及 DataTables 数据中包含该字段，值与既存链路最新数据一致 | FRC AC-005 |
| AC-006：集計レポート支持 | 集計报表结果中可呈现该字段（配置方式可能非勾选，但需确保用户可选择并展示） | FRC AC-006, U-001 |
| AC-007：最新口径正确 | 字段值等于基于 `customer_notes.id` 最大记录关联而来的 `cdr.start_date`（或其他链路口径） | FRC AC-007, U-003 |
| AC-008：无数据时显示 `-` | 所有输出通道无数据时输出字符串 `-` ，不出现空/`(空白)`/`N/A` 等不一致 | FRC AC-008, U-004 |
| AC-009：表形式 CSV 输出 | 表形式 CSV 文件包含该列，标题与数据正确 | FRC AC-009 |
| AC-010：集計 CSV 输出 | 集計 CSV 文件包含该列 | FRC AC-010 |
| AC-011：api_find_report 同步 | API 响应中包含该字段，取值口径一致 | FRC AC-011 |
| AC-Regression-001~005：既存功能不受影响 | 未勾选时其他字段无异常；顧客対応履歴侧/Cdr 页面不变；原有 CSV/API 输出无多余字段 | FRC 回归 AC |

## 11. Risks / Cautions
- **リスク 1 - 最新口径理解偏差**：「最新」虽已确认为沿用既存链路，但该链路的具体取数路径（`customer_notes` max id → cdr）容易与直觉的“按発着信時間取最新”相混淆，开发、测试、验收阶段均需反复确认逻辑无误。  
  - 来源：FRC §11 风险1；CI 结论

- **リスク 2 - 集計レポート实现扩散**：集計レポート现有数据结构与表形式完全不同，引入 cdr 字段可能导致额外 join 或子查询，影响性能和数据一致性，必须单独设计并测试，不可简单复制表形式的字段映射。  
  - 来源：FRC §11 风险2；CI §7

- **リスク 3 - 順番的动态性**：`順番` 依赖自定义字段存在数量，验收时需以具体测试环境下的全列表最大顺序为准，避免写成固定数字。  
  - 来源：FRC §11 风险3

- **リスク 4 - 无数据展示不一致**：现有代码有多处空值处理逻辑（空串、`N/A`、`(空白)`），统一改成 `-` 需要排查所有分支，避免遗漏导致部分通道输出异常。  
  - 来源：FRC §11 风险4；CI §5

- **リスク 5 - CSV/API 输出不一致**：多个输出通道可能由不同函数生成，存在取值差异风险，必须逐通道验证。  
  - 来源：FRC §11 风险5

- **リスク 6 - 参考页面误用**：`/admin/cdr/index` 的视觉顺序并非严格按 `start_date` 降序，若测试/验收时以此为基准，可能误判。  
  - 来源：FRC §11 风险6

- **リスク 7 - 权限未澄清**：若后续出现特定角色不可见的需求，本次全量开放的实现可能导致返工。  
  - 来源：FRC §11 风险7

- **歧义 - 名称与口径**：领导原话“発信日付”与用户补充“発着信日時（最新）”的差异未最终拍板，工程实现时需根据确认后的具体字段名和粒度调整，严禁自行简化或推测。  
  - 来源：FRC §11 歧义1

## 12. Handoff to M3 Code-grounded Plan
- **实现严禁事项**：M3 计划阶段仍不可直接输出代码、SQL、patch/diff；不可将代码调查中推测的文件列表升格为“必须修改文件”。
- **集計レポート必须独立评估**：不能默认采用表形式的实现方式，M3 需明确集計链路如何获取 cdr 数据、如何配置用户选择项、以及性能影响分析。
- **“最新”逻辑的工程落地**：M3 需详细描述如何复用现有「顧客最新情報」既存链路中的“最新”查询逻辑，并将结果映射到新字段，避免新写一套取数逻辑。
- **无数据时 `-` 的统一处理**：M3 需规划在所有输出通道（画面、CSV、API）中如何统一输出 `-`，并处理可能的多语言表示（例如 `global.blank` 的替换）。
- **順番的动态保证**：M3 需说明如何在自定义字段数量变化时确保新增字段始终排在列表末尾。
- **名称与粒度的最终对齐**：M3 启动前必须确认字段名是“発着信日時”还是“発信日付”，以及时间精度是“日時”还是“日付”；计划中应预留适配空间，不可硬编码。
- **Unknown 跟进**：多语言、列宽/排序/筛选、权限可见性、菜单路径仍为 Unknown，M3 不应提前默认处理；若在 M3 阶段这些事项仍未确认，需标记为“待确认后补充方案”。
- **AC 映射的转换**：M3 计划可将本卡 §10 的工程验收要点转化为可验证的技术测试用例，但仍不进入具体代码编写。
