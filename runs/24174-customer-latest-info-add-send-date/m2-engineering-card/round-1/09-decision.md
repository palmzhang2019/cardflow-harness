# Engineering Requirement Card Decision

## Decision Result

**Winner: claude**

## Score Summary

| Candidate | Total Score | Key Strengths | Key Weaknesses |
|-----------|-------------|---------------|----------------|
| codex | 4.35 | 来源类型徽标可追溯性高；零边界越界；Risks 章节保留歧义不擅自消解；§12 明确告诉 M3「候选调查面 ≠ 必须修改文件清单」 | 缺少 ID 体系，AC 与 Constraint/Output 间为叙述性映射；Code Investigation Facts 未带 `file:line`；未细分业务/工程 Unknown |
| claude | 5.00 | 完整 ID 体系（CBR/EC/AO/CIF/U-B/U-E/R/H）；每条 CIF 带 `file:line`；独创业务 Unknown（U-B）与工程 Unknown（U-E）双层分离，主动识别 U-E-01（X/Y/V 归属）、U-E-04（`-` 显示统一位置）；§12 Handoff 10 条约束明确 | 篇幅最长阅读成本相对高；个别 EC 条目（如 EC-05）接近"实现指引"边缘但仍守在约束层 |
| deepseek | 3.25 | 输出结构齐全；AC Mapping 用表格呈现；保留"発信 vs 発着信"歧义至 Unknowns；继承 Frozen Card 风险项 | **边界违规**：AC-007 把"`customer_notes.id` 最大 → `cdr.start_date`"推测升格为业务验收事实；§7 擅自承诺"至少日文"多语言；§12 接近指定实现方向；引用了 M1 不存在的 U-009/U-010/U-011/U-012（脑补来源） |

## Tie-breaker Analysis

不适用——claude 以总分 5.00 显著领先（codex 4.35、deepseek 3.25），无平局。

## Winner Justification

claude 在全部六个维度上同时取得满分，且**唯一不存在边界违规**：

1. **requirement_alignment (5/5)**：通过 CBR-01~CBR-12 完整保留 Frozen Requirement Card 的业务表述，未做任何改写。
2. **code_fact_grounding (5/5)**：CIF-01~CIF-15 每条均带 `file:line` 行号锚点，事实与推测严格区分——这是 codex（缺行号）与 deepseek（推测升格为事实）都无法做到的。
3. **engineering_scope_clarity (5/5)**：表形式 / 集計 / CSV / api_find_report 四领域分节展开，明确点出"集計侧 X/Y/V 与表形式独立选择入口"这一关键工程差异。
4. **boundary_control (5/5)**：零 SQL / 零 patch / 零字段命名方案；EC 章节虽贴近实现指引但严守约束层语义。与 deepseek 形成最强对比——deepseek 的 AC-007 / §7 / §12 均有滑移。
5. **unknowns_quality (5/5)**：U-B vs U-E 双层 Unknown 是独家创新，U-E-01（集計 X/Y/V 归属）、U-E-04（`-` 显示统一实现位置）是只有结合代码事实才能识别出的工程未知。
6. **m3_handoff_readiness (5/5)**：CBR/EC/AO/CIF/U-B/U-E/R/H 完整 ID 体系使 AC Mapping 交叉引用最严密；§12 Handoff 10 条约束直接限定 M3 不得升格候选文件、不得输出 patch/SQL。

而 deepseek 因 AC-007 将代码推测升格为业务验收事实、§7 擅自承诺多语言范围、§12 措辞接近指定实现方向、且引用 M1 不存在的 U-009~U-012 ID（凭空构造），触发**规则 1（违规必败）**层面的严重扣分（boundary_control 仅 2 分）；codex 虽零越界、纪律性优秀，但缺 ID 体系与文件行号锚点，颗粒度不足，无法支撑 M3 的精确引用需求。

按**规则 2（总分优先）**：claude(5.00) > codex(4.35) > deepseek(3.25)，claude 胜出。

## Next Step

将 claude 候选作为输入，运行 `05-merge-selected-card.md` 生成最终 Engineering Requirement Card。
