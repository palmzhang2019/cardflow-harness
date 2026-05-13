按指令「只输出决策报告正文」，以下是 Round 2 Decision 正文：

---

# Round 1 Decision

## 1. Decision Summary

本轮 Requirement Card 抽卡决策结论：以 **Codex (Candidate A)** 作为 frozen 主卡基础，吸收 Claude (Candidate B) 的歧义双维度拆解、自我边界声明、参考页面排序警示与下一阶段拆分思路；吸收 DeepSeek (Candidate C) 中关于「集計レポート目前未包含 cdr 相关数据」这一业务层差异（必须先用业务语言改写）；丢弃 DeepSeek 全部代码层标识符与代码调查结论升级表述、以及 Claude 中泄漏的代码标识符。所有 Unknowns 必须原样保留至下一卡阶段，不得在本决策阶段消除。

本决策仅做抽卡与合并规则定义，不生成新的 Requirement Card 正文，不进入 Engineering Requirement Card，不写 SQL / patch / diff / 实现方案。

---

## 2. Selected Base Candidate

**Candidate A: Codex**

- 评分总分：77（三张候选最高）
- `no_implementation_leakage`：10（满分，三张候选唯一）
- `unknowns_quality`：10（满分，颗粒度最细 13 条）
- `scope_control`：10（满分）
- `acceptance_criteria_quality`：10（AC 全部业务化可手动验证）
- `usefulness_for_next_stage`：10（满分）

---

## 3. Selection Reason

1. **评分 winner**：依据 08-score.json，Codex 总分 77 > Claude 72 > DeepSeek 52，无强理由反转，按评分基准定为主卡。
2. **需求语言纯净度最高**：几乎不使用 `target=1/2`、`type=1/2`、`cdr.start_date`、`customer_notes.max(id)`、`privilege.conf` 等代码层标识符，最符合 Requirement Card 阶段「业务语言、不替实现拍板」的定位。
3. **已确认 / 推测 / 未知 三态分层最干净**：主卡冻结后被错误升级为实现指令的风险最低，与本卡「不能把代码事实升级为业务事实」的红线一致。
4. **"最新"口径完全置于 Unknown 3**：两个候选均用业务语言描述（"按 `発着信時間` 本身取最新" vs "沿用现有既存链路中的最新定义"），不需要做业务化回退处理。
5. **Out of Scope 与「给后续 Engineering 的输入提醒」自我边界声明最严格**：显式禁止把代码调查升级为实现指令、禁止把候选文件升级为必须修改文件。
6. **Unknowns 颗粒度最细**：13 条，并把"用户补充原话中的 `* 集計レポート` 究竟是要求还是线索"作为独立 Unknown 13，符合本阶段「不消除 Unknown」原则。
7. **AC 完全业务化**：未出现任何代码字段名作为 AC 表达（与 DeepSeek AC-Regression-003 使用 `Cdr.start_date` 形成对比），可手动验收。

---

## 4. Content to Absorb

### 4.1 From Codex

作为主卡基础，**全文保留**为合并基线。本节不列额外吸收项（08-score.json 的 `absorb_from_codex` 同为空）。

### 4.2 From Claude

吸收以下**需求层面**内容（不吸收任何代码标识符或实现细节）：

1. **歧义 1 双维度并列拆解**：将 Codex 的「歧义 1」表述替换/合并为 Claude 的双维度并列结构——「発信」/「発着信」与「日付」/「日時」拆成两个独立维度，分别说明各自对数据筛选条件的影响，并指出二者共同决定了对数据筛选条件的不同理解。
2. **一句话需求摘要末尾的自我边界声明**：吸收 Claude 摘要末尾"该项目所对应「最新」的判定口径见 Unknowns，本卡阶段不替业务侧拍板"的措辞，加在 Codex 第 2 节末尾。
3. **风险 6 的详细警示措辞**：吸收 Claude「`/admin/cdr/index` 默认排序更接近 `id DESC`，不能直接等同 `start_date DESC` 口径」这一对参考页面排序与「最新」口径不严格对齐的详细描述，扩写主卡风险 6（`id DESC` / `start_date DESC` 作为口径概念可保留，因其用于警示口径偏差，不构成实现方案）。
4. **下一阶段拆分思路**：吸收 Claude「给后续阶段的提醒」中「"展示一个名为発着信日時（最新）的项目"与"该项目背后的最新判定口径"是两件事，下一卡阶段必须分别处理」的明确拆分要求，加入 Codex 第 12 节。

### 4.3 From DeepSeek

仅吸收**需求层面 Unknown / 风险提示**，不吸收实现内容：

1. **集計链路差异的业务化描述**：吸收 DeepSeek 关于"集計レポート目前未包含 cdr 相关数据，一旦纳入会触及取数链路调整"这一业务层差异说明，加入主卡风险 2 作为补充。**必须先用业务语言改写**：去掉 `target=`、`type=`、`cdr` 等代码标识符，改写为"集計レポート现有数据范围与表形式不同，若集計也被纳入本次范围，会触及现有数据范围之外的内容，影响面会明显扩大"之类业务表达。

除上述一条业务化改写后的差异说明外，**DeepSeek 不再吸收任何其他内容**。

---

## 5. Content to Discard

明确丢弃以下内容，**不进入合并主卡**：

1. **DeepSeek 全部代码层标识符**：`target=1`、`target=2`、`target=1（顧客対応履歴）`、`target=2（顧客最新情報）`、`type=1`、`type=2`、`X/Y/V`、`cdr.start_date`、`customer_notes.max(id)`、`privilege.conf` 等。
2. **DeepSeek 将代码调查结论标记为「已确认」的表述**：包括但不限于「`target=2（顧客最新情報）` 的数据取数逻辑是通过"最新 customer_note"关联，其"最新"判定链路与 `cdr.start_date` 无直接关系」「`項目（*必須）` 区块仅在表形式（type=1）显示；集計（type=2）使用不同的字段选择方式（X/Y/V 下拉）」「`/admin/cdr/index` 中「発着信時間」对应 `cdr.start_date`」等——这些是代码调查结论，不能在主卡阶段升级为业务事实。
3. **DeepSeek AC-Regression-003 的字段名表达**：`target=1（顧客対応履歴）` 侧的既存 `Cdr.start_date` 项目行为不受影响——一律用业务名「顧客対応履歴侧既存発着信時間相关项目」替代。
4. **DeepSeek 风险 7**：关于 `privilege.conf` 未实现 action 的描述——DeepSeek 自己也写了"与本次需求无直接业务关系"，属于代码调查附产物，不进入主卡。
5. **Claude Unknown 3 候选 B 的代码层链路描述**：「沿用既存「顧客最新情報」链路的最新语义，即 `customer_notes.max(id)` 链路所关联到的 cdr」——保留 Codex 现有的纯业务语言表述「沿用现有「顧客最新情報」既存链路中的"最新"定义」。
6. **Claude 第 5 条「当前现状」中的代码标识符**：「`項目（*必須）` 区块仅在表形式（type=1）配置中存在；集計（type=2）使用 X/Y/V 下拉」——保留 Codex 业务化表述「`項目（*必須）` 这一块对应的是表形式レポート的项目选择；集計レポート的选择形式不同」。
7. **DeepSeek 风险 1 中的代码字段表达**：「现有「顧客最新情報」链路用 `customer_notes.max(id)`，业务表达可能期望 `cdr.start_date` 最新」——保留 Codex / Claude 中的业务语言表述。
8. **任何形式的 SQL、字段命名、性能设计、i18n key、patch、diff、实现方案**：本决策阶段与下一阶段（10-selected-requirement-card.md 合并阶段）一律不引入。

---

## 6. Unknowns That Must Remain

以下 Unknowns 必须在合并后主卡中**原样保留**，本决策阶段**不得消除、不得收敛、不得在本卡阶段拍板**：

| # | Unknown | 来源 | 保留理由 |
|---|---|---|---|
| 1 | 本次是否只要求「表形式レポート」支持 `発着信日時（最新）` | Codex U1 / Claude U1 / DeepSeek U1 | 范围未拍板，必须业务侧确认 |
| 2 | 「集計レポート」是否也必须支持 `発着信日時（最新）` | Codex U2 / Claude U2 / DeepSeek U2 | 集計链路与表形式不同，影响面差异极大 |
| 3 | `発着信日時（最新）` 中"最新"的判定口径（候选 A vs 候选 B） | Codex U3 / Claude U3 / DeepSeek U3 | 本卡最关键 Unknown，必须由业务侧拍板，不得由实现侧自行决定 |
| 4 | 客户无発着信履歴数据时的显示规则（空 / `-` / `N/A` / `(空白)` 等） | Codex U4 / Claude U4 / DeepSeek U4 | 业务侧显示规范未指定 |
| 5 | `順番` "最后一位" 的精确语义（系统项目最后 vs 全列表最后） | Codex U5 / Claude U5 / DeepSeek U5 | 视觉结果可能不同 |
| 6 | CSV 是否属于本次范围 / 表形式 CSV / 集計 CSV 是否都属于本次范围 | Codex U6 + U8 / Claude U6 / DeepSeek U6 | 派生输出范围未确认 |
| 7 | `api_find_report` 是否需要同步影响 | Codex U7 / Claude U7 / DeepSeek U7 | 对外接口范围未确认 |
| 8 | 完整菜单进入路径 | Codex U12 / Claude U8 / DeepSeek U8 | 不影响需求本身，影响 AC 手动操作描述 |
| 9 | 多语言文案 / 翻译范围（仅日文 vs 覆盖其他语言） | Codex U9 / Claude U9 / DeepSeek U9 | 多语言范围未确认 |
| 10 | 列宽 / 排序 / 筛选的默认行为 | Codex U10 / Claude U10 / DeepSeek U10 | 报表查看页面新列默认行为未确认 |
| 11 | 权限可见性（特定角色下是否不可见 / 不可选） | Codex U11 / Claude U11 / DeepSeek U11 | 业务可见性规则未确认 |
| 12 | 用户补充原话中的 `* 集計レポート` 究竟是要求还是线索 | Codex U13 | 颗粒度最细的独立 Unknown，影响 Unknown 1、2 的最终拍板 |

**强制约束**：以上 12 条 Unknowns 在合并后的 10-selected-requirement-card.md 中必须全部保留。不得因为某条 Unknown 在 Comparison 或 Score 中讨论过就视作已收敛；本决策阶段不消除任何 Unknown。

---

## 7. Merge Rules for 10-selected-requirement-card.md

合并到 10-selected-requirement-card.md 时，必须遵循以下规则：

### 7.1 基线规则
1. **以 Codex 全文为合并基线**：除明确指定的吸收点外，其余结构与内容沿用 Codex。
2. **不新建章节、不改章节编号**：第 1–12 节结构与 Codex 一致。

### 7.2 章节级合并规则

| 章节 | 合并规则 |
|---|---|
| 第 1 节「原始需求保真」 | Codex 原文保留，三张候选完全一致，无需变动 |
| 第 2 节「一句话需求摘要」 | Codex 原文 + 吸收 Claude 末尾自我边界声明（"该项目所对应「最新」的判定口径见 Unknowns，本卡阶段不替业务侧拍板"） |
| 第 3 节「用户真实目标」 | Codex 原文保留 |
| 第 4 节「业务对象与操作路径」 | Codex 原文保留 |
| 第 5 节「当前现状」 | Codex 原文，但**将第 5 条「当前代码调查显示，「顧客最新情報」既存数据链路中的"最新"口径，与"按発着信日時本身取最新"并不一定相同」从 已确认 改为 推测**，与 Claude 处理对齐 |
| 第 6 节「期望结果」 | Codex 原文保留 |
| 第 7 节「明确范围 In Scope」 | Codex 原文保留 |
| 第 8 节「明确不做 Out of Scope」 | Codex 原文保留 |
| 第 9 节「需要确认 Unknowns」 | Codex 原文 13 条 Unknowns **全部保留**，不合并、不删减、不消除 |
| 第 10 节「验收标准 Acceptance Criteria」 | Codex 原文保留（已全部业务化，无需修改） |
| 第 11 节「风险与歧义」 | Codex 原文，但做三处扩写：① 风险 2 末尾追加业务化补充（吸收 DeepSeek 后去代码标识符）；② 风险 6 用 Claude 的详细措辞扩写参考页面排序与"最新"口径偏差；③ 歧义 1 改为 Claude 双维度并列拆解 |
| 第 12 节「给后续 Engineering 的输入提醒」 | Codex 原文 + 吸收 Claude「"展示一个名为発着信日時（最新）的项目"与"该项目背后的最新判定口径"是两件事，下一卡阶段必须分别处理」一条 |

### 7.3 严格禁止项

合并时**严格禁止**以下行为：

1. 引入任何代码层标识符：`target=1/2`、`type=1/2`、`X/Y/V`、`cdr.start_date`、`customer_notes`、`customer_notes.max(id)`、`privilege.conf`、`Cdr.start_date` 等。
2. 把任何 Unknown 在本阶段拍板、收敛或消除。
3. 把代码调查结论作为「已确认」事实写入主卡。
4. 引入任何 SQL、字段命名、性能设计、i18n key、patch、diff、实现方案。
5. 把"可能相关文件"升级为"必须修改文件"。
6. 在 AC 中使用代码字段名（如 DeepSeek 的 `Cdr.start_date`）。
7. 添加未在三张候选中出现过的、由合并阶段新创造的需求要素。
8. 改写或省略领导原话与用户补充原话（必须 1:1 保留）。

### 7.4 业务化改写规则

当吸收 DeepSeek 内容时（仅集計链路差异一条），必须：

- 去掉 `cdr`、`target=`、`type=` 等代码标识符；
- 用业务名词（「集計レポート」「表形式レポート」「現有数据范围」「取数范围」等）替代；
- 改写后语句必须读起来像业务描述，而非代码调查摘录。

参考改写示例（仅示例，最终以合并执行时为准）：
- DeepSeek 原文："集計レポート（type=2）一旦也要支持，会触及当前集計数据链路未包含 cdr 的事实"
- 业务化改写后："若集計レポート也被纳入本次范围，集計现有的数据范围与表形式不同，会触及现有数据范围之外的内容，影响面将明显扩大于仅在表形式追加一项"

### 7.5 校验清单

合并完成后，10-selected-requirement-card.md 必须满足：

- 全文无 `target=`、`type=`、`cdr.start_date`、`customer_notes.max(id)`、`privilege.conf` 等代码标识符。
- 12 条 Unknowns 全部保留。
- 领导原话与用户补充原话 1:1 保留。
- 无任何 SQL / patch / diff / 字段命名 / 性能设计 / i18n 实现细节。
- AC 全部业务化可手动验收。
- 第 5 节中代码调查结论一律标记为 推测 或剥离至风险条目。
- 第 11 节歧义 1 为双维度并列拆解。
- 第 12 节包含「项目展示」与「最新判定口径」必须分别处理的拆分提醒。

---

注：09-decision.md 的文件写入未获权限，已按 instruction「只输出决策报告正文」直接输出。如需写入文件，请允许写入 `…/m1-requirement-card/round-2/09-decision.md`。
