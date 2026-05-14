# M2 Build Script Investigation Report

> Task: 24174-customer-latest-info-add-send-date
> Stage: M2 Engineering Requirement Card Draw
> Investigation scope: 7 M2 build scripts, 7 M2 prompt files, 3 generated 00-input-*.md files
> Investigator: CardFlow Harness 脚本问题调查 Agent
> Date: 2026-05-14

---

## 1. Executive Summary

全部 7 个 M2 build 脚本存在相同的 heredoc 定界符不匹配（delimiter mismatch）bug：以 `<<'EOF_MARKER'` 开启 heredoc，却以 `EOF`（而非 `EOF_MARKER`）关闭。由于定界符不匹配，heredoc 不会在预期位置终止，而是吞噬后续所有 shell 命令直到脚本末尾，导致这些 shell 代码被原样写入输出文件。这直接导致 3 个已生成的 `00-input-*.md` 文件从第 119 行开始包含 shell 脚本代码（`cat ... >> "$INPUT_FILE"`、`echo "OK: generated ..."`、`ls -lh ...` 等），而本该出现的 Frozen Requirement Card、Code Investigation Report、Confirmed Unknowns、M1 Summary 等真实内容全部缺失。错误源全部位于 build 脚本中，prompt 文件未被污染。

---

## 2. Confirmed Problem

### 2.1 生成文件包含 shell 脚本代码

**文件:** [`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-codex.md`](.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-codex.md:119)
**行 119-155 包含如下 shell 代码（而非真实内容）：**
```
EOF

cat "$FROZEN_REQUIREMENT_CARD" >> "$INPUT_FILE"

cat >> "$INPUT_FILE" <<'EOF_MARKER'
...
cat "$CODE_INVESTIGATION_REPORT" >> "$INPUT_FILE"
...
echo "OK: generated $INPUT_FILE"
ls -lh "$INPUT_FILE"
```

**同样问题存在于:**
- [`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-claude.md`](.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-claude.md:119)
- [`.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-deepseek.md`](.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-deepseek.md:119)

### 2.2 真实内容缺失

生成的三个文件中，`## 1. Frozen Requirement Card`、`## 2. Code Investigation Report` 等章节标题虽然出现，但紧跟其后的是 shell 代码而非实际内容。验证命令 `grep -n '## 1. Frozen Requirement Card' -A 30 00-input-codex.md` 确认：标题行之后立即出现 `EOF`、`cat "$FROZEN_REQUIREMENT_CARD" >> "$INPUT_FILE"` 等命令，没有实际的 Frozen Requirement Card 内容。

---

## 3. Root Cause Analysis

### 3.1 直接根因：Heredoc 定界符不匹配

以 [`build-m2-candidate-input.sh`](.cardflow-harness/scripts/build-m2-candidate-input.sh:54) 为例：

```bash
54: cat >> "$INPUT_FILE" <<'EOF_MARKER'
55:
56: ---
57:
58: ## 1. Frozen Requirement Card (M1 Final Output)
59:
60: EOF        # ← BUG: 应为 EOF_MARKER，不是 EOF
61:
62: cat "$FROZEN_REQUIREMENT_CARD" >> "$INPUT_FILE"
```

- 第 54 行以 `<<'EOF_MARKER'` 开启 heredoc（单引号引用，禁止变量展开）
- 第 60 行以 `EOF` 结束——但 bash 期望的是 `EOF_MARKER`
- 由于 `EOF` ≠ `EOF_MARKER`，heredoc **没有终止**
- 第 62–95 行的所有 shell 命令被 bash 视为 heredoc 的内容，一并写入 `$INPUT_FILE`
- 直到脚本末尾（EOF，即 end-of-file），heredoc 才被迫终止

### 3.2 为何脚本不报错

Bash 对于未终止的 heredoc 在脚本末尾时会**静默接受**（视为 heredoc 在文件末尾隐式结束），不会报错，但所有中间内容都被当作文本写入文件。这解释了为什么脚本 exit code 为 0，却产生了错误输出。

### 3.3 前置 heredoc 为何正确

每个脚本的前两个 heredoc（`<<'HEADER'` 和 `<<EOF`）工作正常，因为其定界符匹配正确：
- `<<'HEADER'` 由 `HEADER` 关闭（第 35/38 行）
- `<<EOF` 由 `EOF` 关闭（第 40/50 行）

第三个 heredoc 起使用 `<<'EOF_MARKER'` 但试图用 `EOF` 关闭，从此开始出错。

### 3.4 是否为复制粘贴错误

是。7 个脚本的代码结构高度一致，极可能是从某个模板复制后，将打开定界符改为 `'EOF_MARKER'` 但忘记修改对应的关闭定界符，或反之。

---

## 4. File-by-file Findings

### 4.1 M2 Build Scripts

| 文件 | 状态 | 证据 | 影响 |
|------|------|------|------|
| [`build-m2-candidate-input.sh`](.cardflow-harness/scripts/build-m2-candidate-input.sh) | **Broken** | 第 54 行 `<<'EOF_MARKER'` 第 60 行 `EOF` 不匹配；第 64/74/84 行同样 | 生成的 00-input-*.md 全部污染 |
| [`build-m2-candidate-input-round2.sh`](.cardflow-harness/scripts/build-m2-candidate-input-round2.sh) | **Broken** | 第 57/67/77/87/98/109/120 行 `<<'EOF_MARKER'` → `EOF` 不匹配 | 若执行，生成的 00-input-*.md 将污染 |
| [`build-m2-comparison-input.sh`](.cardflow-harness/scripts/build-m2-comparison-input.sh) | **Broken** | 第 51/61/71 行 `<<'EOF_MARKER'` → `EOF` 不匹配 | 若执行，生成的 06-input-comparison.md 将污染 |
| [`build-m2-score-input.sh`](.cardflow-harness/scripts/build-m2-score-input.sh) | **Broken** | 第 52/62/72/82 行 `<<'EOF_MARKER'` → `EOF` 不匹配 | 若执行，生成的 06-input-score.md 将污染 |
| [`build-m2-decision-input.sh`](.cardflow-harness/scripts/build-m2-decision-input.sh) | **Broken** | 第 50/60 行 `<<'EOF_MARKER'` → `EOF` 不匹配 | 若执行，生成的 06-input-decision.md 将污染 |
| [`build-m2-merge-input.sh`](.cardflow-harness/scripts/build-m2-merge-input.sh) | **Broken** | 第 63/73 行 `<<'EOF_MARKER'` → `EOF` 不匹配 | 若执行，生成的 06-input-merge-selected.md 将污染 |
| [`build-m2-freeze-input.sh`](.cardflow-harness/scripts/build-m2-freeze-input.sh) | **Broken** | 第 56 行 `<<'EOF_MARKER'` → `EOF` 不匹配 | 若执行，生成的 00-input-freeze.md 将污染 |

### 4.2 M2 Prompt Files

| 文件 | 状态 | 证据 |
|------|------|------|
| [`01-generate-candidate.md`](.cardflow-harness/prompts/m2-engineering-card/01-generate-candidate.md) | **OK - 洁净** | 仅包含 prompt 指令文本，无 shell 代码 |
| [`02-compare-candidates.md`](.cardflow-harness/prompts/m2-engineering-card/02-compare-candidates.md) | **OK - 洁净** | 仅包含 prompt 指令文本，无 shell 代码 |
| [`03-score-candidates.md`](.cardflow-harness/prompts/m2-engineering-card/03-score-candidates.md) | **OK - 洁净** | 未发现 shell 代码（grep 验证） |
| [`04-decide-winner.md`](.cardflow-harness/prompts/m2-engineering-card/04-decide-winner.md) | **OK - 洁净** | 未发现 shell 代码（grep 验证） |
| [`05-merge-selected-card.md`](.cardflow-harness/prompts/m2-engineering-card/05-merge-selected-card.md) | **OK - 洁净** | 未发现 shell 代码（grep 验证） |
| [`06-freeze-engineering-card.md`](.cardflow-harness/prompts/m2-engineering-card/06-freeze-engineering-card.md) | **OK - 洁净** | 未发现 shell 代码（grep 验证） |
| [`11-generate-candidate-round2.md`](.cardflow-harness/prompts/m2-engineering-card/11-generate-candidate-round2.md) | **OK - 洁净** | 未发现 shell 代码（grep 验证） |

### 4.3 Generated 00-input-*.md Files

| 文件 | 状态 | 证据 | 影响 |
|------|------|------|------|
| [`00-input-codex.md`](.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-codex.md) | **Polluted** | 第 119–155 行包含 shell 代码 | 不能用作模型输入 |
| [`00-input-claude.md`](.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-claude.md) | **Polluted** | 第 119–155 行包含 shell 代码 | 不能用作模型输入 |
| [`00-input-deepseek.md`](.cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-deepseek.md) | **Polluted** | 第 119–155 行包含 shell 代码 | 不能用作模型输入 |

---

## 5. Scope of Damage

### 5.1 已污染文件（必须处理）

- **`round-1/00-input-codex.md`** — 已被 shell 代码污染，需删除并重新生成
- **`round-1/00-input-claude.md`** — 已被 shell 代码污染，需删除并重新生成
- **`round-1/00-input-deepseek.md`** — 已被 shell 代码污染，需删除并重新生成

### 5.2 有风险的后续产出

如果先修复脚本再重新生成，以下文件不会受影响：
- 后续模型生成的 candidate 文件（`01-candidate-*.md`）— 尚未创建或使用正确输入
- comparison/score/decision/merge/freeze 阶段的输入文件 — 尚未生成（或若已生成也需检查）

### 5.3 未被污染

- **所有 prompt 文件** — 洁净，无需修改
- **M1 产出文件**（Frozen Requirement Card、Code Investigation Report、Confirmed Unknowns、M1 Summary）— 正确完好
- **脚本的目录结构、文件检测逻辑、变量定义** — 功能正确，只需修复 heredoc

### 5.4 判断

| 问题 | 结论 |
|------|------|
| 00-input-*.md 是否需要删除并重新生成？ | **是**。三个文件从头生成 |
| Prompt 文件是否需要重建？ | **否**。洁净无污染 |
| Build 脚本是否需要重写？ | **需要修复**（定界符改正即可，不必整体重写） |

---

## 6. Recommended Fix Strategy

### 6.1 修复所有 7 个 build 脚本中的 heredoc 定界符

将所有 `<<'EOF_MARKER'` ... `EOF` 改为 `<<'EOF'` ... `EOF`（统一使用 `EOF` 作为定界符），或全部改为 `<<'EOF_MARKER'` ... `EOF_MARKER`。关键是**打开和关闭定界符必须完全一致**。

具体修复方案（仅描述策略，不提供完整脚本）：

**方案 A（推荐）：统一使用 `EOF`**
把每个脚本中所有 `<<'EOF_MARKER'` 改为 `<<'EOF'`。这样与脚本中已有的第一个 `<<EOF`（无引号）风格一致，但要注意：
- 已展开变量的部分（`- task_id: ${TASK_ID}` 等）使用无引号 `<<EOF`
- 静态文本部分使用单引号 `<<'EOF'` 防止意外展开

**方案 B（备选）：统一使用 `EOF_MARKER`**
保留所有 `<<'EOF_MARKER'`，但把每个 `EOF` 关闭行改为 `EOF_MARKER`。这种方式改动点更多。

### 6.2 避免复杂 heredoc 嵌套

重构时可以改用 `{ echo "..."; cat file; } > "$OUTPUT_FILE"` 模式，避免多个追加 heredoc 的复杂结构：

```bash
# 替代方案示例（非完整脚本）：
{
  echo "# Model Input"
  echo ""
  echo "- task_id: ${TASK_ID}"
  ...
  echo ""
  echo "## Instruction"
  cat "$PROMPT_FILE"
  echo ""
  echo "## 1. Frozen Requirement Card (M1 Final Output)"
  cat "$FROZEN_REQUIREMENT_CARD"
  ...
} > "$INPUT_FILE"
```

这种模式不需要 heredoc，消除了定界符不匹配的风险。

### 6.3 删除并重新生成 round-1 的 00-input-*.md

```bash
# 修复脚本后执行：
rm .cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-*.md
bash .cardflow-harness/scripts/build-m2-candidate-input.sh 24174-customer-latest-info-add-send-date round-1 codex
bash .cardflow-harness/scripts/build-m2-candidate-input.sh 24174-customer-latest-info-add-send-date round-1 claude
bash .cardflow-harness/scripts/build-m2-candidate-input.sh 24174-customer-latest-info-add-send-date round-1 deepseek
```

### 6.4 修复后验证

见第 7 节验证命令。

---

## 7. Verification Commands

以下命令在修复后运行，用于验证生成文件的正确性：

### 7.1 检测 shell 代码残留

```bash
# 检测所有生成输入文件中是否还含有 shell 命令残留
grep -nE 'cat "\$|EOF|EOF_MARKER|echo "OK"|ls -lh|set -euo pipefail|INPUT_FILE=|OUTPUT_FILE=|PROMPT_FILE=|>> "\$|<<.?EOF' \
  .cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-*.md || true

# 期望输出：无匹配（或仅匹配正常 Markdown 中的合法内容）
```

### 7.2 验证真实内容已正确拼接

```bash
# 验证 Frozen Requirement Card 内容已出现（非 shell 代码）
grep -n '## 1. Frozen Requirement Card' -A 30 \
  .cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-codex.md

# 验证 Code Investigation Report 内容已出现
grep -n '## 2. Code Investigation Report' -A 30 \
  .cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-codex.md

# 期望输出：章节标题后的内容应为实际文本，而非 shell 命令
```

### 7.3 确认无 `EOF_MARKER` 泄漏

```bash
# 确保生成文件中没有意外写入的 EOF_MARKER
grep -c 'EOF_MARKER' \
  .cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-*.md || true

# 期望输出：0（每个文件 0 个匹配）
```

### 7.4 验证文件完整性

```bash
# 检查三个文件行数是否合理（预期 > 200 行，视真实材料长度而定）
wc -l \
  .cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-*.md

# 检查文件末尾是否以正常内容结束（不是 shell 命令）
tail -5 \
  .cardflow-harness/runs/24174-customer-latest-info-add-send-date/m2-engineering-card/round-1/00-input-codex.md
```

---

## 8. Final Judgment

### **不可以继续跑三模型，必须先修脚本**

**理由：**

1. **已确认 3 个 00-input-*.md 文件全部被 shell 代码污染**，模型收到的输入包含大量 shell 命令而非期望的工程材料。如果以当前文件运行三模型推理，模型的输出将基于错误的输入产生，结果无意义。

2. **污染的根本原因在 build 脚本**（heredoc 定界符不匹配），而非 prompt 文件或材料文件。只需修复 7 个 build 脚本，重新生成 00-input-*.md，即可继续后续流程。

3. **Prompt 文件和所有材料文件完好**，无需重建，修复成本低、时间短。

4. **修复后必须重新生成三个 00-input-*.md 文件并验证**，确认无 shell 代码残留、确认真实内容正确拼入后，再运行三模型推理。

**推荐修复优先级：** 先修复 [`build-m2-candidate-input.sh`](.cardflow-harness/scripts/build-m2-candidate-input.sh)（当前轮次），再修复其余 6 个脚本（防止后续轮次再次出现同类问题）。
