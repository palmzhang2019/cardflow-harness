# Round 1 Decision

## 1. Decision Summary

本 Round 1 抽卡决策的最终结论是：**采用 Codex（Candidate A）作为主卡基础**，吸收 Claude（Candidate B）的 AC 编号体系 / 回归项写法 / `id DESC` vs `start_date DESC` 风险点 / "禁止脑补"硬性声明 / Unknowns 处置要求；**仅**从 DeepSeek（Candidate C）吸收"风险表表格形式"与"同一顾客多条 cdr 测试数据准备"这一句需求层面提醒；DeepSeek 的所有 In Scope / Out of Scope 范围决断、所有实现层级内容（property file、`num` 分配、system field 定义、`privilege.conf`、`ApplicationResources.properties`、画面级操作路径断言等）**全部丢弃**。

所有原始 Unknowns 必须原样保留，禁止在本决策阶段对任何 Unknown 做出消解、归并或事实化。

---

## 2. Selected Base Candidate

**Candidate A：Codex**

- 评分 winner：Codex = 79，Claude = 75，DeepSeek = 40
- 评分维度上，Codex 在 `scope_control`、`unknowns_quality`、`no_implementation_leakage`、`usefulness_for_next_stage` 四个维度同时满分
- 没有出现需要反转评分 winner 的强理由

---

## 3. Selection Reason

选择 Codex 作为主卡基础，原因如下：

1. **章节级"已确认 / 推测 / 未知"三层分类**：Codex 是三张 Candidate 中唯一在 §3 用户真实目标、§4 业务对象与操作路径、§5 当前现状、§6 期望结果中均显式拆分"已确认 / 推测 / 未知"三层的卡片。Claude 仅依靠 §9 Unknowns 章节兜底，DeepSeek 则把多个本应是 Unknown 的项目升级为 In Scope / Out of Scope。

2. **关键 Unknown 全部未做范围决断**：Codex §7 In Scope 中对 `表形式レポート` / `集計レポート` / CSV / 表形式 CSV / 集計 CSV / `api_find_report` 五项明确标记为"需保留为待确认范围"，没有任何一项被擅自归入 In Scope 或 Out of Scope。

3. **"最新"口径的中立保留**：Codex §6 明确列出 `Cdr.start_date` 最大值与 `customer_notes.id` 最大值两条候选解释而不做选择，§9 Unknowns #3 与 §11 风险章节均保留这一未确认状态，符合 M1 阶段"严禁脑补"的硬性要求。

4. **零实现方案泄漏**：Codex 不含 SQL、property file、`num` 分配、系统字段定义、权限文件级别细节、画面 URL 级别的扩展操作路径等任何实现层内容。

5. **§12 已具备越界预防条款**：Codex 已写入"代码调查报告的'可能相关文件 / 最小修改候选范围'不能直接转写为'必须修改文件'"，对后续 Engineering Requirement Card 阶段做了预防性约束。

---

## 4. Content to Absorb

### 4.1 From Codex

Codex 作为主卡本体，整体结构与三层分层全部保留，不存在"从 Codex 吸收"的吸收项；以下作为主卡骨架直接沿用，**不视为吸收**：

- §1 原始需求保真的引文区块与"已确认 / 推测 / 未知"分层
- §3 / §4 / §5 / §6 章节级三层分层结构
- §7 In Scope 中"需保留为待确认范围"的范围写法
- §8 Out of Scope 中"本卡不包含实现方案 / SQL / patch / diff" 等元约束
- §9 全部 10 条 Unknowns
- §11 高风险 / 歧义 / 过程风险三层叙述
- §12 关于"代码调查报告不能升级为必须修改文件"的越界预防条款

### 4.2 From Claude

吸收范围严格限定在以下需求层内容，不吸收章节本体：

1. **AC 编号体系（AC-001…，AC-Regression-001…）**：将 Codex 现有的 §10 AC 改写为统一编号格式，含 AC-Regression 回归项分组。
2. **AC 与 Unknown 的显式绑定写法**：含范围依赖的 AC（CSV / 集計 / 最新口径 / 無データ表示 / 順番"最后一位"）需显式标注"以 Unknowns #X 确认结果为准"。
3. **AC-Regression-003**："`target=1（顧客対応履歴）` 既有的 `Cdr.start_date` 行为不受影响" 这一回归项作为需求层风险点的体现，可吸收。
4. **§11 风险条目：`/admin/cdr/index` 默认 `id DESC` 并非 `start_date DESC`，"视觉最新"与严格 `start_date` 最大值不天然等价**——补入主卡 §11 的歧义项中。
5. **§9 Unknowns 末尾硬性声明**：原文"以上 Unknowns 必须保留，禁止在本卡片中替领导脑补回答"，追加到 Codex §9 末尾。
6. **§12 Unknowns 处置要求**：原文"本卡片所有保留的 Unknowns 与风险，必须在 Engineering Requirement Card 中逐项给出处置方式（确认 / 推迟 / 排除范围）"，追加到 Codex §12。

### 4.3 From DeepSeek

吸收范围严格限制为 2 项，仅限需求层 / 表现层：

1. **风险章节的表格展示形式**：将 Codex §11 主体的三层叙述（高风险 / 歧义 / 过程风险）以"风险 | 影响 | 深刻度"三列表格形式呈现，**只采用表格形态**，表格内容仍以 Codex §11 + Claude §11 中 `id DESC` 风险为准，绝不引用 DeepSeek §11 中与其自身 §7 矛盾的措辞。
2. **测试数据准备提醒**（仅一句，作为需求层后续提醒）："最新発着信判定の検証用に、同一顧客に `start_date` の異なる複数の cdr を用意するテストデータが必要"——追加到主卡 §12 末尾作为后续阶段提醒。

---

## 5. Content to Discard

以下内容**严禁**进入合并后的 10-selected-requirement-card.md：

### 5.1 DeepSeek 的范围决断（来自 §7 In Scope）

- "対象レポートタイプ: 表形式レポート（`type=1`）" → 这是 Unknown #1，不可写为 In Scope
- "対象集計対象: `target=2`（顧客最新情報）" → `target=2` 是代码调查得出的实现概念，不属于需求层
- "顧客ごとに発着信履歴（cdr）の `start_date` が最大となるレコードを参照し、その `start_date` を表示する" → 这是 Unknown #3 中两个候选口径之一，不可写为已确认数据取得逻辑
- "レポート出力対応：表形式レポートの CSV ダウンロード" → 这是 Unknown #5，不可写为 In Scope

### 5.2 DeepSeek 的 Out of Scope 越界（来自 §8）

- "集計レポート（`type=2`）への対応（現時点では要件に含めない）" → 这是 Unknown #2，不可划入 Out of Scope
- "API `api_find_report` の改修（必要かどうか未確認のため、意図的なスコープ外）" → 这是 Unknown #7，"未确认所以不做"在 M1 阶段属于不可接受的范围决断
- "CDR 一覧画面（`/admin/cdr/index`）の改修" → 该画面在领导原话与补充原话中未被提及，不需在 Out of Scope 显式排除，避免暗示其与需求相关
- "他ターゲット（`target=1`）への展開" → `target=1` 是代码调查实现概念
- "カスタム項目（`CustomerContactExt.field*`）の自動追加" → 实现层概念

### 5.3 DeepSeek 混入的实现方案（全部丢弃）

- "システムフィールドとして `発着信日時（最新）` を定義" → 实现指令
- "日本語ロケールのプロパティファイルに `発着信日時（最新）` を追加" → i18n 文件级实现细节
- "実装時に `num` の割り振り方を指示する" → 字段编号实现细节
- "`ApplicationResources.properties` に加え、他言語のリソースファイルにも同様のキーを定義" → 文件名 / 键定义级实现细节
- "`privilege.conf` にレポートダウンロード用の未使用アクションが存在するため、今回の対応で混入させないよう注意する" → 代码调查结论搬入
- DeepSeek §6 中"表形式レポートの表示画面およびダウンロード（CSV）において、…の値が表示される" → 把 Unknown #5（CSV）当作已确认结果

### 5.4 DeepSeek 代码调查级的操作路径扩展（来自 §4）

- "レポート編集: `admin/customer_contact_history_reports/edit`" → 代码调查得出的 URL，领导原话未提及
- "レポート表示: 表形式レポート詳細画面" → 代码调查得出的画面级断言

### 5.5 DeepSeek AC 章节中的越界部分

- AC-1 中"`campaign` と `target`（`顧客最新情報` に相当するもの）を選択する" → `campaign` / `target` 是代码调查实现概念，不在需求原话中
- AC-4 中"`2026-05-13 10:30:00`" 这类具体格式举例 → 表示格式属于实现表现层，且未在原话中确认
- AC-5 中"最も新しい `start_date` の値" → 把 Unknown #3 当作已确认
- AC-8 整条"CSV ダウンロード（スコープに含む場合）" → 改用主卡 §10 中以 Claude 方式绑定 Unknown 的写法

### 5.6 DeepSeek §12 中所有指向具体文件 / 字段 / 权限的提醒

- 第 4 项"`num` の割り振り方を指示する"
- 第 6 项"`ApplicationResources.properties`"及多语言 resource 文件提醒
- 第 7 项"既存データのマイグレーション"具体实现指引
- 第 8 项"`privilege.conf`"权限文件相关提醒

### 5.7 DeepSeek 整体 §5 / §6 中将 Unknown 当作现状或期望结果的描述

- §5 "集計レポートの選択肢（X/Y/V）にも当該項目は存在しない" 中的 X/Y/V 实现细节
- §6 "表形式レポートの表示画面およびダウンロード（CSV）" 把 CSV 升级为期望结果

---

## 6. Unknowns That Must Remain

合并后主卡 §9 **必须**完整保留以下全部 Unknowns，禁止在本次决策阶段做出任何范围决断、口径选择或事实化：

1. **U-1**：本次是否仅要求 `表形式レポート` 支持 `発着信日時（最新）`（Codex §9 #1）
2. **U-2**：`集計レポート` 是否也必须支持 `発着信日時（最新）`（Codex §9 #2）
3. **U-3**："最新" 口径是 `Cdr.start_date` 最大值还是 `customer_notes.id` 最大值（Codex §9 #3）
4. **U-4**：无 `発着信履歴` 数据时的显示规则（空字符串 / `-` / `（空白）` / `N/A` / 其他）（Codex §9 #4）
5. **U-5**：`順番` 的"最后一位"判定基准（系统字段最后 vs 含自定义字段的全列表最后）（Codex §9 #5）
6. **U-6**：CSV（表形式 CSV / 集計 CSV）是否属于本次验收范围（Codex §9 #6 + #8）
7. **U-7**：`api_find_report` 是否需要同步影响（Codex §9 #7）
8. **U-8**：领导原话"発信日付"与补充项名 `発着信日時（最新）` 是否完全同义 / 最终显示名以哪个为准（Codex §9 #9 + Claude §9 #1 后半的命名歧义）
9. **U-9**：`/admin/cdr/index` 是仅作参考页面，还是其字段口径应被视为本需求标准来源（Codex §9 #10）
10. **U-10**：完整菜单导航路径（从入口到 `admin/customer_contact_history_reports/add`）（Claude §9 #8）

合并后必须在 §9 末尾保留硬性声明（吸收自 Claude）：

> 以上 Unknowns 必须保留，禁止在本卡片中替领导脑补回答。

---

## 7. Merge Rules for 10-selected-requirement-card.md

合并时必须严格遵守以下规则：

### 7.1 骨架与编号

1. **基准骨架**：完整使用 Codex 的 §1 ~ §12 章节结构与序号，不重新编排。
2. **不新增章节**：除非吸收内容能自然归入现有章节，否则不创建新章节。
3. **章节级三层分层（已确认 / 推测 / 未知）**：§3 / §4 / §5 / §6 必须显式保留。

### 7.2 §1 原始需求保真

- 完整保留 Codex §1 的两个引文区块及"已确认 / 推测 / 未知"小节，不动文字。

### 7.3 §7 In Scope / §8 Out of Scope

- §7 严格沿用 Codex 写法，保留"已确认纳入"与"按材料需保留为待确认范围"两个子段。
- §8 严格沿用 Codex 写法，保留"本卡不包含（元约束）"与"当前不能确认纳入本次的内容"两个子段。
- **绝对禁止**：将 U-1 / U-2 / U-5 / U-6 / U-7 / U-8 中任何一项移入 In Scope 或 Out of Scope 的"已确认"子段。

### 7.4 §9 Unknowns

- 以 Codex §9 10 条作为主集合。
- 追加 Claude §9 #8（完整菜单导航路径），作为第 11 条。
- 末尾追加 Claude 的硬性声明："以上 Unknowns 必须保留，禁止在本卡片中替领导脑补回答。"
- 不合并、不删减、不重述任何一条。

### 7.5 §10 Acceptance Criteria

- 全面改写为 Claude 的编号体系：
  - 正向项：`AC-001`、`AC-002` …
  - 回归项：`AC-Regression-001`、`AC-Regression-002` …
- 所有依赖 Unknown 的 AC 必须显式标注"以 Unknowns #X 确认结果为准"：
  - 涉及"最新"口径的 AC → 绑定 U-3
  - 涉及无数据展示的 AC → 绑定 U-4
  - 涉及"順番 最后一位" 的 AC → 绑定 U-5
  - 涉及 CSV 的 AC → 绑定 U-6
  - 涉及 API 的 AC → 绑定 U-7
  - 涉及集計の AC → 绑定 U-2
- 必须包含至少一条 AC-Regression，针对"既存项目显示名 / 順番 / 勾选行为 / 未勾选时既有报表输出"的不变性。
- 追加 Claude AC-Regression-003 同等含义条目：未勾选 / 其他场景下既有 `Cdr.start_date` 相关行为不受本次新增字段影响。

### 7.6 §11 风险与歧义

- 主体改为表格形式（吸收自 DeepSeek 形式），三列结构为：`# | 风险 / 歧义 | 影响 / 深刻度`。
- 表格内容来源**仅限**：
  - Codex §11 现有的高风险 / 歧义 / 过程风险条目（全部）
  - Claude §11 中"`/admin/cdr/index` 默认 `id DESC` 并非 `start_date DESC`" 一条
- **绝对禁止**引用 DeepSeek §11 表格中的 R1 措辞（其与自身 §7 矛盾）。
- 表格中"深刻度"为定性标注（高 / 中 / 低），不做量化估算。

### 7.7 §12 给后续 Engineering Requirement Card 的输入提醒

- 完整保留 Codex §12 全部内容。
- 末尾追加 Claude §12 中以下两点（按需求层措辞改写）：
  - "本卡片所有保留的 Unknowns 与风险，必须在 Engineering Requirement Card 中逐项给出处置方式（确认 / 推迟 / 排除范围）"
  - "代码调查报告中的所有'可能相关文件''最小修改候选范围''调用链'均只能作为后续 Engineering Requirement Card 阶段的参考，不得在本阶段升级为'必须修改文件'或实现指令"（与 Codex §12 现有条款合并，不重复）
- 追加 DeepSeek §12 中**唯一**可吸收一句（需求层提醒，不含实现细节）：
  - "最新発着信判定の検証用に、同一顧客に `start_date` の異なる複数の cdr を用意するテストデータが必要"

### 7.8 合并禁止清单（硬约束）

合并时，以下内容在 10-selected-requirement-card.md 中**一律不得出现**：

- 任何 SQL、patch、diff
- 任何具体文件名（`ApplicationResources.properties`、`privilege.conf`、property file 等）
- 任何字段编号 / `num` 分配级别细节
- 任何系统字段定义指令（"システムフィールドとして … を定義"等）
- 任何代码调查得出的具体 URL（`admin/customer_contact_history_reports/edit` 等）作为"已确认操作路径"
- 任何代码调查实现概念（`target=1` / `target=2` / X/Y/V / `CustomerContactExt.field*`）作为需求层事实
- 任何对 Unknown 的隐性消解（例如"※要確認"括注但仍写入 In Scope 数据逻辑的写法）
- 任何"未确认所以排除"式的范围决断

### 7.9 命名一致性

- 主卡内文统一使用领导补充原话给出的 `発着信日時（最新）` 作为字段名工作占位，但同时在 §9 U-8 中保留"最终命名以业务方书面确认为准"的未确认状态，**不得**在本卡片任何位置以"最终命名"措辞出现。
- 不在主卡中创造新字段别名（如"最新ノート発着信日時"等），DeepSeek §12 中此类备选命名的建议**整体丢弃**。

### 7.10 合并后自检清单

合并完成后，须逐项确认：

- [ ] §7 In Scope 中没有出现 U-1 / U-2 / U-5 / U-6 / U-7 / U-8 的任何"确认事实"
- [ ] §8 Out of Scope 中没有出现"未确认所以排除"的措辞
- [ ] 全文未出现 SQL / patch / diff / 具体文件名 / 字段编号
- [ ] §3 ~ §6 各章节均显式存在"已确认 / 推测 / 未知"三层
- [ ] §9 Unknowns 至少包含 11 条且末尾含硬性声明
- [ ] §10 AC 全部为 AC-XXX / AC-Regression-XXX 编号，含 Unknown 绑定
- [ ] §11 为表格形式，含 `id DESC` vs `start_date DESC` 风险
- [ ] §12 含"代码调查不可升级为必须修改"约束 + Unknowns 处置要求 + 测试数据准备提醒
