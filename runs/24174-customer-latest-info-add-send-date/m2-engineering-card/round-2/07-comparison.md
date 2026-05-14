# Engineering Requirement Card Comparison Report

## Candidates Overview

- **codex**：结构最丰富，使用统一 ID 体系（CBR/ES/AO/CIF/EC/OOS/U-B/U-E/AC/R/H），CIF 全部带 `file:line` 锚点，显式拆分业务/工程 Unknowns，并多处给出"与 Round 1 差异"说明；但章节数量与重复表达较多，阅读密度较高。
- **claude**：组织最清爽，CIF 完整且补充了 CIF-16（admin_edit/admin_view），Handoff 章节明确以"前提约束清单"句式表达，边界控制最严格；少量条目（如 CIF-16）未带行号，AO 编号较 codex 略简（未列 `/admin/cdr/index` 参考面）。
- **deepseek**：内容覆盖完整，对关键 CIF 加了"重要性"标注；但 CBR-04/05/06/07 把 Frozen 原文措辞改为"支持并展示/输出"，EC-03/EC-05、R-01、H-02 含"必须加入 cdr 关联""严禁提出 cdr.start_date 替代方案"等接近实现指引/方案禁令的强指令措辞，越过了 M2 边界。

## Dimension Scores

| Dimension | codex | claude | deepseek |
|-----------|-------|--------|----------|
| requirement_alignment | 9 | 9 | 7 |
| code_fact_grounding | 9 | 9 | 8 |
| engineering_scope_clarity | 9 | 9 | 8 |
| boundary_control | 9 | 9 | 6 |
| unknowns_quality | 9 | 9 | 8 |
| m3_handoff_readiness | 8 | 9 | 7 |

## Strengths and Weaknesses

### codex
**Strengths**
- 统一 ID 体系，CBR ↔ AO ↔ EC ↔ AC ↔ H 多向交叉引用最完整。
- CIF 全部带 `file:line`，并明确"参考事实"与"约束"的区别（如 EC-02 处理 CBR-09 与 CIF-04 的张力）。
- 显式区分"权限可见性 Unknown（U-B-03）"与"权限机制本身不在本卡确认范围（OOS-08）"，消解 Round 1 的歧义。
- AO-09 单列 `/admin/cdr/index` 为 Reference Only，避免被误升格为修改对象。
- H-05/H-07 明确"候选相关文件 ≠ 必须修改文件"，边界控制到位。

**Weaknesses**
- 表达密度高，多处"与 Round 1 差异"块重复，影响整体可读性。
- 同一信息在 §4 / §5 / §10 反复出现，章节冗余略多。

### claude
**Strengths**
- 章节结构最克制，第 12 章用"前提约束句式"重写，最贴合 M2 边界要求。
- 新增 CIF-16 补齐 `admin_edit/admin_view` 渲染面的事实，使 AO-02 / CBR-12 有了独立代码事实依据。
- U-E-01 显式标记"M3 前置阻塞项"，并说明"若不引入则 CBR-05 无法满足"，阻塞性表达最清晰。
- AO 编号紧凑，输出面与 CBR/EC 映射一致；Acceptance Mapping 同时绑定 CBR 与 EC。
- 全程未出现"必须如何实现 / 严禁某实现方案"等指令性表述。

**Weaknesses**
- CIF-16 未给出具体行号（仅文件路径），与其它 CIF 的精度不一致。
- 未单独列出 `/admin/cdr/index` 作为参考输出面（codex 有 AO-09），略弱于 codex 的"参考 vs 主动修改"显式区分。

### deepseek
**Strengths**
- 对关键代码事实（CIF-04 / CIF-06 / CIF-07 / CIF-09）加了"关键事实"标注，引导力强。
- R-01 / R-07 把"实现者/测试者不得自行修正口径"写得显眼，对最大风险点的提醒最清楚。
- 列出 Round 1 来源与决策文件，让 Round 2 改进点的来源可追溯。

**Weaknesses（边界违规警示）**
- **CBR-04/05/06/07 改写 Frozen 原文措辞**："支持" → "支持并展示/输出"，违反"不改写业务需求"约束（requirement_alignment 扣分）。
- **EC-03**：「将强制要求现有集計 SQL...加入 cdr 关联」— 直接指向实现方向。
- **EC-05**："M3 阶段必须为 5 条输出链路分别或统一地设计 `-` 的生成点" — 落到方案层。
- **H-02**："严禁提出任何以 cdr.start_date 排序取最新的替代方案" — 是对方案的禁令，越过卡片职责。
- **R-01**将"测试者"纳入约束，超出工程需求卡片范围。
- 整体方向正确，但多处词句已从"约束"漂到"实现指引/禁令"，是本轮三个候选中边界控制最弱的一份。

## Recommended Priority

1. **claude** — 边界控制最严，结构最克制，Handoff 章节最贴合 M2 "约束式"句式，CIF-16 补齐了 AO-02 的事实依据，最适合作为 M3 输入。
2. **codex** — 内容最完整，ID 体系与交叉引用最严谨，AO-09 显式标记 `/admin/cdr/index` 为参考面是 claude 缺的优点；但表达密度过高、章节冗余略多，整体可作为强候选或与 claude 互补。
3. **deepseek** — 风险提醒和事实标注有亮点，但多处条目漂入实现方向/方案禁令，且 CBR 措辞与 Frozen 原文不完全一致，需要先按 M2 约束清理边界后才宜作为 M3 输入。
