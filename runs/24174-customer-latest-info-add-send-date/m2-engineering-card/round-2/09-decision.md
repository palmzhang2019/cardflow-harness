# Engineering Requirement Card Decision

## Decision Result

**Winner: claude**

## Score Summary

| Candidate | Total Score | Key Strengths | Key Weaknesses |
|-----------|-------------|---------------|----------------|
| codex | 4.9 | 统一 ID 体系、CIF 全部带 `file:line` 锚点、AO-09 显式标记 `/admin/cdr/index` 为参考面、交叉引用最完整 | 表达密度过高、章节冗余多、`§4/§5/§10` 反复出现相同信息，m3_handoff_readiness 扣 1 分 |
| claude | 5.0 | 边界控制最严（无任何"必须实现/严禁方案"措辞）、第 12 章 Handoff 用"前提约束句式"重写、新增 CIF-16 补齐 AO-02 事实依据、U-E-01 明确标注"M3 前置阻塞项" | CIF-16 仅给出文件路径未带行号，与其他 CIF 精度不一致；未单列 `/admin/cdr/index` 作为参考输出面 |
| deepseek | 3.4 | 对关键 CIF 加"关键事实"标注、R-01/R-07 对"口径不得自行修正"提醒清晰、Round 1 来源可追溯 | **多处边界违规**：CBR-04/05/06/07 改写 Frozen 原文（"支持"→"支持并展示/输出"）、EC-03"必须加入 cdr 关联"、EC-05"必须为 5 条输出链路设计 - 的生成点"、H-02"严禁提出 cdr.start_date 替代方案"、R-01 将"测试者"纳入约束 |

## Tie-breaker Analysis

不适用。三个候选的 `total_weighted_score` 互不相同（claude 5.0 > codex 4.9 > deepseek 3.4），无需启用平局规则。

## Winner Justification

按决策规则逐条核验：

**规则 1（违规必败）核验**
- claude：全程未出现代码、SQL、具体实现方案，未改写 Frozen 原文措辞 → 无违规。
- codex：内容密度高但未越界到实现/方案层 → 无违规。
- deepseek：虽未直接写代码或 SQL，但 EC-03"必须加入 cdr 关联"、EC-05"必须为 5 条输出链路设计 - 的生成点"、H-02"严禁提出 cdr.start_date 替代方案"已落到方案层与方案禁令；CBR-04/05/06/07 改写 Frozen 原文措辞违反"不改写业务需求"约束。这些属于 M2 边界违规，按规则 1 应直接淘汰。

**规则 2（总分优先）核验**
即使不触发规则 1 淘汰 deepseek，claude 的 `total_weighted_score = 5.0` 也是三者中最高（codex 4.9，deepseek 3.4），直接判定 claude 胜出。

**核心选择理由**
claude 在六个维度上均拿到满分（5/5），是唯一一份在 `boundary_control` 与 `m3_handoff_readiness` 同时拿满分的候选：
1. **边界控制最严**：第 12 章 Handoff 全部以"前提约束句式"表达（"M3 必须在不变更…的前提下…"），未越界到"必须如何实现"或"严禁某实现方案"，完美符合 M2 卡片职责。
2. **要求对齐最准**：CBR-01~CBR-12 严格保留 Frozen 原文措辞，未做语义升格（对比 deepseek 把"支持"改写为"支持并展示/输出"）。
3. **事实基础扎实**：CIF-01~CIF-15 全部带 `file:line`，并补充 CIF-16 为 AO-02（admin_edit/admin_view 渲染面）提供独立代码事实依据，使 codex 也未覆盖的输出面变得有据可循。
4. **Unknowns 阻塞性最清晰**：U-E-01 显式标注"M3 前置阻塞项"，并说明"若不引入则 CBR-05 无法满足"，让 M3 入场前的依赖关系一目了然。
5. **Handoff 就绪度最高**：结构最克制，无重复章节，可直接作为 M3 输入而无需边界清理。

codex 唯一相对优势（AO-09 显式标记 `/admin/cdr/index` 为参考面）属于补充信息，在 M3 的 merge 阶段可以从 codex 卡借入 claude 卡，不影响 claude 作为胜者的判定。

## Next Step

将胜出的候选 **claude** 作为输入，运行 `05-merge-selected-card.md` 生成最终 Engineering Requirement Card。建议在 merge 阶段考虑从 codex 卡补入以下两项作为增强（不改变胜者结论）：
1. `AO-09`：将 `/admin/cdr/index` 显式列为 Reference Only 输出面，避免被 M3 误升格为修改对象。
2. 为 claude 的 CIF-16（`admin_edit` / `admin_view` 渲染面）补齐具体 `file:line` 行号，使所有 CIF 精度一致。
