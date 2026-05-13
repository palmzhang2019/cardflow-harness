# Round 1 Decision

## 1. Decision Summary

本轮 Requirement Card 抽卡决策的最终结论：以 **Candidate B (Claude)** 为主卡基础（base candidate），吸收 Candidate A (Codex) 的“代码调查不得升级为实现指令”总括措辞、`発信 vs 発着信 / 日付 vs 日時` 的歧义说明、`/admin/cdr/index` 排序的隐性偏差描述；从 Candidate C (DeepSeek) 仅吸收次级 Unknown 条目（多语言、列宽 / 排序 / 筛选、权限可见性）与操作路径步骤化的 AC 手动指引写法。DeepSeek 中所有实现层内容（字段命名、SQL、性能设计、i18n key）以及 §8 中错误拍板的 Out of Scope 条目（集計不做、API 暂不保证等）必须明确丢弃。所有未确认范围（type=2 集計 / CSV / `api_find_report` / 「最新」口径 / 順番边界 / 无数据显示规则）必须在合并阶段继续保留为 Unknowns，不允许在本轮抽卡阶段升级为 In Scope 或 Out of Scope。

## 2. Selected Base Candidate

**Candidate B (Claude)**

评分总分：79（三张中最高，与第二名 Codex 75 分差距明显，与第三名 DeepSeek 41 分差距巨大）。

## 3. Selection Reason

1. **评分 winner，无强理由反转。** 08-score.json 明确 winner = claude，且与 Codex 在多个高权重维度同分，仅在 `acceptance_criteria_quality` 与 `usefulness_for_next_stage` 上明显领先。本轮无任何业务级强理由触发反转规则。
2. **结构完整度最高。** 已确认 / 推测 / 未知三层标记 + AC 编号 + Regression AC 编号 + Unknowns 编号 + 给 Engineering 卡的输入提醒，全套齐全，便于后续逐条收敛追踪与版本化管理。
3. **范围控制最严格。** CSV / 集計レポート / `api_find_report` 全部放进 Unknowns，§8 末尾还显式加注「不在此处提前判定」，杜绝了 DeepSeek 出现的“Unknown 被误拍板”问题。
4. **「最新」口径处理最佳。** 用 候选 A / 候选 B 二选一的形式让业务侧直接勾选，是三张中收敛效率最高的写法。Codex 仅保留为 Unknown 但未给出选项形式。
5. **覆盖面比 Codex 更完整。** 显式覆盖了 `admin_edit` / `admin_view` 的一致性，是 Codex 未覆盖、DeepSeek 在 In Scope 中混入实现细节的部分。
6. **完全无实现污染。** 与 Codex 同为 10/10，不进入 SQL / 字段命名 / 性能设计 / i18n key 等工程卡产物。

## 4. Content to Absorb

### 4.1 From Codex

合并阶段从 Codex 吸收以下三条，均为需求/澄清层面，无实现内容：

- **§12 总括措辞**：「代码调查只能作为需求澄清依据，不能直接跳成实现指令」——作为新主卡 §12 的开篇总括句，强化对工程卡阶段的边界要求。
- **歧义说明**：「発信 vs 発着信 / 日付 vs 日時」的表述差异——Claude 已有歧义 1，但 Codex 措辞更显式，合并时强化此条歧义的描述。
- **隐性偏差描述**：「`/admin/cdr/index` 默认排序更接近 `id DESC`，不能直接等同 `start_date DESC` 口径」——补强到 Claude §11 风险 6 的现有描述上。

### 4.2 From Claude

不另行“吸收”，因 Claude 即为主卡基础，全文保留。

### 4.3 From DeepSeek

仅吸收以下次级条目，且全部以 **Unknown 形式**纳入，不进入 In Scope / Out of Scope，也不带入任何实现细节：

- **新 Unknown：多语言文案 / 翻译范围**——是否仅日文即可，是否覆盖中文 / 英文等其他语言包。
- **新 Unknown：列宽 / 是否可排序 / 是否可筛选的默认行为**——报表查看页面中新列的默认行为是否需要业务侧指定，还是采用系统默认。
- **新 Unknown：权限可见性**——是否需要限制该新增字段在特定角色 / 权限下不可见或不可选。
- **AC 手动执行指引的步骤化写法**——DeepSeek §4 的编号步骤形式可借鉴用于 AC-001 ~ AC-007 的手动操作描述方式，但 AC 本身仍以 Claude 现有编号体系为准。

## 5. Content to Discard

以下 DeepSeek 内容必须明确从合并基础中剔除，不得带入新主卡的任何条目：

1. **字段命名建议**：`cdr_latest_start_date`（DeepSeek §7 第 5 条 / §12 第 2 条）——属于工程卡的内部映射标识，需求卡不应规定字段名。
2. **SQL 实现策略**：lateral join / 子查询 / 窗口函数 / 应用层聚合等技术选型讨论（DeepSeek §12 第 3 条 / §11 风险 2）——属于实现方案。
3. **性能设计**：DeepSeek §11 风险 2、§12 第 3 条中关于查询性能、`Cdr.start_date DESC` 取数方案的讨论——属于工程卡产物。
4. **i18n 实现建议**：DeepSeek §12 第 6 条「在语言文件中预留 key」——属于实现细节。
5. **§8 错误拍板项**：
   - 「不涉及集計レポート（type=2）」与「不修改 target=2 集計 SQL」——与 DeepSeek 自身 §9 第 2 条 Unknown 矛盾，必须改回 Unknown。
   - 「不修改 API 接口的数据结构」「`api_find_report` 暂不保证本次追加字段自动进入其输出」——与 §9 第 6 条 Unknown 矛盾，必须改回 Unknown。
   - 「不修改 `/admin/cdr/index` 页面」——可保留为 Out of Scope（仅作参考页面，无业务争议），但合并时按 Claude 既有写法（推测）处理。
6. **§7 In Scope 中已拍板的待确认项**：「順番追加在现有系统字段及可能的自定义字段之后（最后一位）」按 In Scope 处理——必须改回 Unknown（順番边界尚未确认）。
7. **§6 / §7 中向 `cdr.start_date` 默认倾斜的口径**：「默认期望按 `Cdr.start_date` 降序取第一条」「现暂按需求提到的 cdr参照 理解为基于 Cdr 表的最新年月日时」——必须改回 Unknown 的“候选 A / 候选 B”形式，不允许在本卡阶段替业务拍板。
8. **CSV 同时出现在 In Scope + AC + Unknowns 的自相矛盾结构**——CSV 范围在合并阶段统一回归到 Unknowns，AC 中暂不包含 CSV 验证条目，待业务确认后补全。
9. **DeepSeek §5 表格中关于 `field_name` / `tableSystemFields` 等代码内部命名描述**——可作为后台理解参考，但不进入合并卡的“当前现状”节，避免代码细节污染需求语言。

## 6. Unknowns That Must Remain

以下 Unknowns 在合并阶段必须保留，不得在本轮抽卡或合并中被消除、合并或升级为 In Scope / Out of Scope：

来自 Claude 的 8 条主线 Unknown：

1. 本次是否只要求「表形式レポート」（type=1）支持 `発着信日時（最新）`。
2. 「集計レポート」（type=2）是否也必须支持 `発着信日時（最新）`。
3. `発着信日時（最新）` 的“最新”判定口径（候选 A：`cdr.start_date` 最大值 / 候选 B：沿用 `customer_notes.max(id)` 关联到的 cdr）。
4. 客户无発着信履歴数据时的显示规则（空 / `-` / `N/A` / `(空白)` / 其他）。
5. `順番`「最后一位」精确语义（候选 A：仅系统字段最后 / 候选 B：含自定义字段后的全列表最后）。
6. CSV 下载（表形式 CSV / 集計 CSV）是否属于本次验收范围。
7. `api_find_report` 对外行为是否需要同步影响（尤其 target=2 时）。
8. 完整菜单操作路径未确认（不影响需求本身，影响 AC 手动操作描述）。

从 Codex 吸收（已隐含于 Claude，合并时强化即可）：

- 用户补充原话中 `* 集計レポート` 是明确业务要求还是仅为调查线索（属于 Unknown 1、2 的进一步澄清依据）。

新增（从 DeepSeek 吸收为 Unknown）：

9. 多语言文案 / 翻译范围（是否仅日文 / 是否覆盖其他语言包）。
10. 列宽 / 是否可排序 / 是否可筛选的默认行为。
11. 权限可见性（是否需要限制该字段在特定权限下不可见或不可选）。

歧义保留：

- 歧义 1：领导原话「発信日付」 vs 用户补充「発着信日時（最新）」——「発信」/「発着信」、「日付」/「日時」表述差异如何对应到 cdr 数据筛选条件。

## 7. Merge Rules for 10-selected-requirement-card.md

合并到 `10-selected-requirement-card.md` 时严格遵循以下规则：

1. **基线 = Claude 原文。** 章节编号、标题、AC 编号 / Regression AC 编号、Unknowns 编号体系全部沿用 Claude，不要重排。Claude 原文中已确认的 In Scope / Out of Scope / AC / 现状条目原样保留，不得删改。

2. **§1 保真区不动。** 领导原话与用户补充原话保持 Claude 现有写法逐字保留，不得替换、改写、归纳。

3. **§11 风险与歧义节，按以下顺序合并强化：**
   - 现有 7 条风险与 1 条歧义保留。
   - 风险 6（`/admin/cdr/index` 默认排序）描述中合并 Codex 措辞，强化「`id DESC` 不能直接等同 `start_date DESC`」的隐性偏差表述。
   - 歧义 1 描述中合并 Codex 措辞，强化「発信 vs 発着信、日付 vs 日時」的双重维度差异。
   - **不**新增任何来自 DeepSeek 的实现层风险（性能、SQL 设计、CSV 编码 / 转义、API 兼容性等不并入）。

4. **§12 给 Engineering Requirement Card 的输入提醒节，开篇追加 Codex §12 总括句：** 「代码调查只能作为需求澄清依据，不能直接跳成实现指令。Engineering Requirement Card 应基于收敛后的 Unknowns 再行决定实际修改面。」其余 6 条提醒沿用 Claude 现有顺序。

5. **§9 Unknowns 节，编号扩展：**
   - 现有 Unknown 1 ~ 8 沿用 Claude 编号与措辞，不动。
   - 在末尾新增 Unknown 9（多语言）、Unknown 10（列宽 / 排序 / 筛选）、Unknown 11（权限可见性），按需求语言描述，不带入 DeepSeek 任何实现层用词（不写「i18n key」「翻译资源文件」「权限 action 配置」等具体技术名词，只描述业务问题）。

6. **§7 In Scope 与 §8 Out of Scope 不得新增条目。** 严格按 Claude 现有边界。CSV / 集計 / API 任何方向的拍板都不允许在本轮加入。`順番` 边界保持 Claude “最后一位（精确语义见 Unknowns）” 的写法，不得改写为 DeepSeek 风格的“追加在系统字段及可能的自定义字段之后”。

7. **§10 AC 节：**
   - AC-001 ~ AC-007 与 AC-Regression-001 ~ AC-Regression-004 沿用 Claude 编号与措辞。
   - AC-006 / AC-007 现有「以 Unknown 3 / Unknown 4 的最终决定为准」的占位写法保留，不得改为具体规则。
   - AC 手动操作描述部分可借鉴 DeepSeek §4 的步骤化写法对 AC-001、AC-005 的“访问 → 选择对象 → 进入项目区 → 确认追加项目”操作链条进行轻度补充，但**不新增 AC 条目**，不引入新的验收点。
   - 末尾保留 Claude 现有注释：「集計レポート / CSV / `api_find_report` 相关 AC 待 Unknowns 1、2、6、7 确认后追加」。

8. **§5 当前现状节：** 全部沿用 Claude 写法，不引入 DeepSeek §5 表格中涉及代码内部命名（`tableSystemFields` / `field_name` 等）的描述，避免代码细节污染需求语言。

9. **DeepSeek 实现内容总闸：** 任何字段命名建议、SQL 策略、性能设计、i18n 实现细节、`api_find_report` 拍板项、集計拍板项、`cdr.start_date` 默认倾斜表述——在合并文档中**禁止以任何形式出现**，包括引用、附录、备注、参考链接。

10. **Unknowns 不消除原则：** 合并阶段不得通过文字技巧（合并、归纳、转移到 Out of Scope）减少 Unknown 数量。即使某条 Unknown 看似可以通过常识判断，也必须保留至业务侧明确回复后再由下一轮 frozen 卡承载。

11. **合并产物文件名固定：** `10-selected-requirement-card.md`，章节顺序与 Claude 一致，不重排。

12. **合并文档不进入工程卡阶段。** 不写 SQL、不写 patch、不写 diff、不写字段映射、不指定必须修改的代码文件、不替业务拍板任何 Unknown。
