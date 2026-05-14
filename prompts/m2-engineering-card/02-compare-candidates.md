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