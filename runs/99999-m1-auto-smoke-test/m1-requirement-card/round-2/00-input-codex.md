# Model Input

- task_id: 99999-m1-auto-smoke-test
- stage: m1-requirement-card
- round: round-2
- model: codex

---

## Instruction

# M1 Requirement Card Candidate Generator - Round 2

你现在是 Requirement Card Candidate 生成 Agent。

你的任务：
基于 Round 1 的 Selected Requirement Card、Comparison、Score、Decision，生成一张 Round 2 Requirement Card Candidate。

当前阶段：
仍然只允许生成 M1 Requirement Card Candidate。

禁止事项：
- 不写代码
- 不写 SQL
- 不生成 patch / diff
- 不生成实现方案
- 不进入 Engineering Requirement Card
- 不生成 Plan
- 不把代码调查报告中的发现升级成实现指令
- 不把“可能相关文件”写成“必须修改文件”
- 不脑补业务规则
- 不消除 Unknowns

Round 2 修正重点：

1. 不要把“最新一条発着信履歴”写成已确认口径。
   正确写法：
   - 已确认：需要展示 `発着信日時（最新）` 这个项目。
   - 未知：该字段的“最新”判定口径是 `cdr.start_date` 最大值，还是沿用既存 `customer_notes.max(id)` 链路。

2. 把“展示字段”与“最新判定口径”拆开。
   不要在期望结果中直接写死“取最新一条発着信履歴”。

3. 减少工程化表述。
   尤其避免反复出现：
   - `集計 SQL 当前未 join cdr`
   - 具体 SQL
   - 字段命名
   - 性能设计
   - i18n key

   可以改成需求化表述：
   - 若集計レポート也纳入范围，当前代码调查显示其数据链路与表形式不同，影响范围可能扩大。

4. 修正权限相关矛盾。
   不要同时写：
   - 权限控制不在范围内
   - 权限可见性是 Unknown

   推荐写法：
   - 推测：本次不主动改权限控制。
   - 未知：是否存在特定角色下该新增项目不可见 / 不可选的业务要求。

5. 保留所有 Unknowns，尤其：
   - 表形式レポート是否为唯一范围
   - 集計レポート是否也必须支持
   - “最新”口径：Cdr.start_date 最大值 vs customer_notes.max(id) 链路
   - 无発着信履歴数据时显示规则
   - 順番最后一位的边界
   - CSV 是否属于本次范围
   - api_find_report 是否需要同步影响
   - 表形式 CSV / 集計 CSV 是否属于本次范围
   - 多语言文案 / 翻译范围
   - 列宽 / 排序 / 筛选默认行为
   - 权限可见性

6. 仍然必须保留领导原话，不美化、不改写。

输出标题必须是：

# Requirement Card Candidate

必须包含以下章节：

1. 原始需求保真
2. 一句话需求摘要
3. 用户真实目标
4. 业务对象与操作路径
5. 当前现状
6. 期望结果
7. 明确范围 In Scope
8. 明确不做 Out of Scope
9. 需要确认 Unknowns
10. 验收标准 Acceptance Criteria
11. 风险与歧义
12. 给后续 Engineering Requirement Card 的输入提醒

只输出 Requirement Card Candidate 本文。

---

## Round 1 Selected Requirement Card

# Selected Requirement Card

## 1. 原始需求保真

领导原话（保留原文）：

```text
"【① 顧客情報レポートについて】
「顧客最新情報」においても発信日付を表示できるようしたい
※現状は「顧客対応履歴」から全履歴を確認いただき、最新の発信日付を抽出いただく必要がございます。"

ベルシステム２４
```

补充原话 / 线索（保留原文）：

```text
発着信日時（最新）→ 発着信履歴に一番最新→ cdr参照

* 表形式レポート
* 集計レポート
```

已确认：
- 目标页面是 `admin/customer_contact_history_reports/add`
- 需求围绕 `顧客情報レポート` / `顧客最新情報`
- 希望新增一个可选项目 `発着信日時（最新）`
- 现状下需要从 `顧客対応履歴` 全履历中人工确认最新发信日付

推测：
- “発信日付”在实际页面/报表项上可能落为 `発着信日時（最新）`
- 数据来源可能与 `cdr` 相关

未知：
- 领导原话中的“発信日付”是否与补充线索中的“発着信日時（最新）”完全同义
- 本次验收是否覆盖表形式、集計、CSV、API 等全部相关出口

---

## 2. 一句话需求摘要

在 `admin/customer_contact_history_reports/add` 中，为 `顧客最新情報` 追加可选项目 `発着信日時（最新）`，使报表可显示该客户“最新”的発着信日時，但“最新”口径及影响范围仍有待确认。

---

## 3. 用户真实目标

已确认：
- 降低用户为查看最新发信相关时间而手工翻查 `顧客対応履歴` 的操作成本
- 让 `顧客情報レポート` 中的 `顧客最新情報` 直接承载该信息

推测：
- 用户希望在报表配置阶段勾选该项后，生成结果时直接看到对应值
- 用户希望该字段的行为与现有报表字段机制保持一致

未知：
- 用户真实目标是否仅限于“看见这个字段”
- 用户是否同时期待该字段参与集計、CSV、API 或其他导出/对外输出

---

## 4. 业务对象与操作路径

业务对象：
- `顧客情報レポート`
- `顧客最新情報`
- `顧客対応履歴`
- `発着信履歴`
- `cdr`

操作路径：

已确认：
- 用户进入 `admin/customer_contact_history_reports/add`
- 在 `項目（*必須）` 区域选择输出项目
- 勾选后生成/查看报表

已确认的字段呈现要求：
- 追加项名称：`発着信日時（最新）`
- 需要出现在 `出力 項目名` 列
- 需要出现在 `表示名` 列
- `順番` 放在最后一位

推测：
- 该项目的勾选与保存行为与既存项目机制一致
- 勾选后报表输出会以现有列展示机制呈现

未知：
- 完整菜单导航路径未确认
- “最后一位”是系统字段最后，还是包含自定义字段后的全列表最后，未确认
- 是否同样作用于 `表形式レポート` 与 `集計レポート`，未确认

---

## 5. 当前现状

已确认：
- `admin/customer_contact_history_reports/add` 的 `項目（*必須）` 由既存字段定义生成
- 当前 `顧客最新情報` 对应字段列表中没有 `発着信日時（最新）`
- 当前报表输出依赖已保存的字段配置进行展示
- 当前 `顧客最新情報` 链路中的“最新信息”现有实现口径与 `customer_notes` 的最新记录有关
- `/admin/cdr/index` 中存在 `発着信時間`，其数据来源为 `cdr.start_date`

推测：
- 现状下用户无法在 `顧客最新情報` 报表中直接看到所需的最新発着信日時
- 现有“最新 note”口径与“最新 cdr”口径可能不一致

未知：
- 无 `発着信履歴` 数据时现有同类字段的期望展示方式
- 当前集計报表是否具备承载该字段的业务含义
- `api_find_report` 当前是否被业务方实际作为验收对象使用

---

## 6. 期望结果

已确认：
- 在 `admin/customer_contact_history_reports/add` 的 `項目（*必須）` 中能看到 `発着信日時（最新）`
- 用户可以勾选该项目
- 勾选后，报表中可展示该客户对应的 `発着信日時（最新）`

推测：
- 该字段应遵循现有字段配置、显示、导出机制
- 若纳入既存报表出口，展示名应为 `発着信日時（最新）`

未知：
- “最新”应按 `Cdr.start_date` 最大值，还是沿用 `顧客最新情報` 现有 `customer_notes.id` 最大值链路
- 无数据时显示空字符串、`-`、`（空白）` 或其他值，未确认
- 是否要求 `集計レポート` 也支持该字段
- 是否要求 CSV / API 同步体现

---

## 7. 明确范围 In Scope

已确认纳入：
- `admin/customer_contact_history_reports/add` 页面中的 `項目（*必須）`
- 新增可选项目 `発着信日時（最新）`
- 该项目在 `出力 項目名`、`表示名` 的可见性
- 勾选后在报表结果中显示对应值这一业务目标

按材料需保留为待确认范围：
- `表形式レポート` 是否属于本次范围：有较强线索，但仍需确认
- `集計レポート` 是否属于本次范围：有线索，但未确认
- CSV 是否属于本次验收范围：未确认
- `api_find_report` 是否需要同步影响：未确认
- 表形式 CSV / 集計 CSV 是否属于本次范围：未确认

---

## 8. 明确不做 Out of Scope

本卡不包含（元约束）：
- 实现方案
- 代码修改指令
- SQL
- patch / diff
- Engineering Requirement Card
- 对 Unknowns 的主观消解
- 将“可能相关文件”升级为“必须修改文件”
- 未经确认的业务规则补全

当前不能确认纳入本次的内容：
- Excel / PDF 输出
- batch / cron
- 邮件配信
- 权限调整
- 其他类似页面统一改造

---

## 9. 需要确认 Unknowns

1. 这次是否只要求 `表形式レポート` 支持 `発着信日時（最新）`
2. `集計レポート` 是否也必须支持 `発着信日時（最新）`
3. `発着信日時（最新）` 的“最新”口径到底是 `Cdr.start_date` 最大值，还是现有 `顧客最新情報` 的 `customer_notes.id` 最大值逻辑
4. 无 `発着信履歴` 数据时应该显示什么（空字符串 / `-` / `（空白）` / `N/A` / 其他）
5. `順番` 的“最后一位”是指系统字段最后，还是包含自定义字段后的全列表最后
6. CSV 是否属于本次验收范围
7. `api_find_report` 是否需要同步影响
8. 表形式 CSV / 集計 CSV 是否属于本次范围
9. 领导原话中的“発信日付”与补充项名 `発着信日時（最新）` 是否需要完全一致，还是允许作为同一业务含义处理；最终显示名以哪个为准，需以业务方书面确认为准
10. `/admin/cdr/index` 仅作为参考页面，还是其字段口径应被视为本需求标准来源
11. 完整菜单导航路径（从入口到 `admin/customer_contact_history_reports/add`）尚未确认

> 以上 Unknowns 必须保留，禁止在本卡片中替领导脑补回答。

---

## 10. 验收标准 Acceptance Criteria

正向项：

- AC-001：手动访问 `admin/customer_contact_history_reports/add`，在 `項目（*必須）` 中可以看到 `発着信日時（最新）`
- AC-002：手动确认 `発着信日時（最新）` 在 `出力 項目名` 列显示为 `発着信日時（最新）`
- AC-003：手动确认 `発着信日時（最新）` 在 `表示名` 列显示为 `発着信日時（最新）`
- AC-004：手动确认 `発着信日時（最新）` 的 `順番` 显示为最后一位（具体口径以 Unknowns #5 确认结果为准）
- AC-005：手动确认 `発着信日時（最新）` 可被正常勾选
- AC-006：保存配置后重新进入编辑或查看页面，`発着信日時（最新）` 的勾选状态保持一致
- AC-007：勾选 `発着信日時（最新）` 后手动生成 / 查看报表，报表中出现 `発着信日時（最新）` 列
- AC-008：准备一个存在多条発着信履歴的客户，手动验证报表中展示的是“最新”一条记录对应时间（“最新”口径以 Unknowns #3 确认结果为准）
- AC-009：当客户无発着信履歴时，报表中按 Unknowns #4 确认结果的口径显示

回归项：

- AC-Regression-001：未勾选 `発着信日時（最新）` 时，既存报表字段显示与现状一致
- AC-Regression-002：既存 `項目（*必須）` 中原有项目的显示名、順番、勾选行为不因本需求发生非预期变化
- AC-Regression-003：未勾选 `発着信日時（最新）` 或其他场景下，既有 `Cdr.start_date` 相关行为不受本次新增字段影响

依赖 Unknown 的待补 AC（确认后补充 AC）：

- 涉及 `集計レポート` 的 AC：以 Unknowns #2 确认结果为准，确认后补充 AC
- 涉及 CSV（表形式 CSV / 集計 CSV）的 AC：以 Unknowns #6 / #8 确认结果为准，确认后补充 AC
- 涉及 `api_find_report` 的 AC：以 Unknowns #7 确认结果为准，确认后补充 AC

> 若本次验收范围不包含 CSV / 集計 / API，则验收时应明确排除这些出口，不作为本次通过条件。

---

## 11. 风险与歧义

| # | 风险 / 歧义 | 影响 / 深刻度 |
|---|-------------|---------------|
| 1 | `顧客最新情報` 现有“最新”实现口径（`customer_notes.id` 最大）与用户补充的“発着信履歴に一番最新→ cdr参照”可能不一致 | 做出来的值可能与业务预期不一致，出货后产生手戻 / 高 |
| 2 | `表形式レポート` 与 `集計レポート` 的字段承载机制并不相同，若范围未先确认，容易产生需求外扩 | 范围、工作量与验收边界发生变化 / 高 |
| 3 | CSV、表形式 CSV、集計 CSV、`api_find_report` 是否随字段新增联动未先界定 | 验收口径会分叉，重要导出/对外通路可能漏掉 / 中 |
| 4 | 领导说的是“発信日付”，补充说的是“発着信日時（最新）”，字段名与业务含义是否完全等价存在歧义 | 命名 / 显示文案不一致，引发后续返工 / 中 |
| 5 | “発信”与“発着信”是否同一含义、是否包含着信，存在表述歧义 | 业务含义边界不清，影响数据取得范围理解 / 中 |
| 6 | “日付”与“日時”表述不一致，颗粒度（日 vs 时刻）尚未明确 | 输出格式与展示精度可能与业务预期不符 / 中 |
| 7 | “順番最后一位”缺少明确参照系（系统字段末尾 vs 含自定义字段的整体末尾） | 实际显示位置与业务预期不一致 / 低 |
| 8 | 无 `発着信履歴` 数据时的空值展示规则未明确 | 多处出口表现不一致，验收时易扯皮 / 低 |
| 9 | `/admin/cdr/index` 当前可见的“视觉最新”与严格按 `start_date` 取最大值并不天然等价；该页面默认 `id DESC` 而非 `start_date DESC` | 若以该页面为基准，可能引入“视觉最新 ≠ 严格最大值”的隐性偏差 / 高 |
| 10 | 代码调查可用于澄清现状，但不能替代业务确认 | 易把“当前如何实现”误读为“本次必须如何实现” / 中 |
| 11 | 若在 M1 阶段提前把某个 Unknown 当成既定规则，会直接污染后续 Engineering Requirement Card | 范围与口径错误向下游传播 / 高 |

---

## 12. 给后续 Engineering Requirement Card 的输入提醒

后续进入 Engineering Requirement Card 前，至少应先明确以下内容：
- 本次范围是否仅限 `表形式レポート`
- `集計レポート` 是否纳入
- CSV、表形式 CSV、集計 CSV 是否纳入
- `api_find_report` 是否纳入
- `発着信日時（最新）` 的“最新”业务口径
- 无 `発着信履歴` 时的显示规则
- `順番最后一位` 的判定基准
- “発信日付” / “発着信日時（最新）”的最终显示名称

同时提醒：
- 代码调查中已确认的是“当前系统怎么做”，不是“本次必须怎么做”
- `/admin/cdr/index` 只能作为参考线索，不能在未确认前直接等同为最终业务规则
- 代码调查报告中的所有“可能相关文件”“最小修改候选范围”“调用链”均只能作为后续 Engineering Requirement Card 阶段的参考，不得在本阶段升级为“必须修改文件”或实现指令
- 后续工程卡需要继续严格区分：已确认 / 推测 / 未知
- 本卡片所有保留的 Unknowns 与风险，必须在 Engineering Requirement Card 中逐项给出处置方式（确认 / 推迟 / 排除范围）
- 测试数据准备提醒：最新発着信判定の検証用に、同一顧客に `start_date` の異なる複数の cdr を用意するテストデータが必要

---

## Round 1 Decision

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

---

## Round 1 Comparison

# Round 1 Candidate Comparison

## 1. 总体结论

三张 Candidate 的需求保真度都尚可，原话均完整保留，主目标识别均正确，且都没有写出 SQL/patch/diff 形式的代码。但在"严格区分 已确认 / 推测 / 未知"、"是否把 Unknown 误当成已确认事实"、"是否混入隐性实现方案"这三个关键判定上，三者差距很大。

- **Codex**：唯一在每个章节（业务对象、现状、期望结果、范围）都内嵌"已确认 / 推测 / 未知"三层分类的卡片，对集計レポート / CSV / API / 最新口径全部明确保留为待确认。最适合作为 frozen requirement card 的基础。
- **Claude**：保真度高，AC 明确编号并含回归项，Unknowns 与风险章节非常严谨，明确警告"禁止脑补"。略弱于 Codex 之处在于章节级别没有把"推测"显式区分出来，但实质上没有把 Unknown 升级为事实。
- **DeepSeek**：在"未知 → In Scope/Out of Scope"上越界最严重，把"集計レポート不做"、"CSV 必须做"、"`Cdr.start_date` 最大值即为最新"等本应是 Unknown 的项目直接当成已确认事实写进了范围与逻辑章节，并混入了多处实现方案。需要大量返工才能用作 frozen 基础。

推荐主卡：**Codex**，吸收 Claude 的 AC 编号体系与回归项写法，对 DeepSeek 仅保留其风险表表达形式，**严禁吸收 DeepSeek 的 In Scope / Out of Scope 写法**。

---

## 2. Candidate A: Codex 评价

### 优点
- 严格的"已确认 / 推测 / 未知"三层分层贯穿"用户真实目标 / 业务对象 / 当前现状 / 期望结果 / 范围"等几乎每一节，是三张中分层最干净的一张。
- 在 §7 In Scope 把表形式/集計/CSV/api_find_report/表形式 CSV/集計 CSV 全部明确列入"需保留为待确认范围"，而不是擅自归入 In/Out of Scope。
- 在 §6 期望结果中对"最新"口径明确写明两条候选解释（`Cdr.start_date` 最大值 vs `customer_notes.id` 最大值），未做选择，未升级为事实。
- §12 明确写出"代码调查报告的'可能相关文件 / 最小修改候选范围'不能直接转写为'必须修改文件'"，对 Engineering Requirement Card 阶段的越界做了预防。
- 完全没有实现方案、SQL、表名修改、property file、num 分配等技术细节。
- AC 全部以手动操作描述，且 AC-8/9/10 明确写明"若本次验收范围包含 CSV / 集計"，避免提前锁死范围。

### 问题
- AC 数量较多但没有像 Claude 那样使用编号体系（AC-001 / AC-Regression-001），追溯时稍逊。
- §11 风险章节是分段叙述式，没有像 DeepSeek 那样的"风险表 + 深刻度"，可读性略弱。
- 部分表述较密集（如 §4 / §5 / §7 内的项目较多），快速浏览时不如 Claude 的项目式列举清晰。

### 可吸收内容
- §1～§7 的"已确认 / 推测 / 未知"三层分层结构 → 主卡核心结构。
- §7 把范围相关 Unknown 明确写为"待确认范围"而非直接归入 In/Out。
- §12 关于"代码调查报告只能作参考、不能升级为必须修改文件"的提醒。

---

## 3. Candidate B: Claude 评价

### 优点
- 原话保真完整，且明确标注引文区块。
- §9 Unknowns 列了 8 条，末尾明确写"以上 Unknowns 必须保留，禁止在本卡片中替领导脑补回答"，立场明确。
- §10 AC 使用 AC-001～AC-008 + AC-Regression-001～003 的编号体系，含回归测试条目，可追溯性最好。
- AC-008 / AC-009 明确写"最新口径以 Unknowns #3 确认结果为准"、"按 Unknowns #4 确认的口径显示"，把范围风险与 AC 显式绑定。
- §11 风险与歧义中专门指出 `/admin/cdr/index` 默认 `id DESC` 而非 `start_date DESC` 的参考页面口径风险，这一点比 Codex / DeepSeek 都更细。
- §12 明确指示"代码调查报告中的所有'可能相关文件''最小修改候选范围''调用链'均只能作为后续 Engineering Requirement Card 阶段的参考，不得在本阶段升级为'必须修改文件'或实现指令"。
- 完全没有混入实现方案。

### 问题
- 章节内部没有像 Codex 那样显式分"已确认 / 推测 / 未知"三层，§4 / §5 / §6 主要靠括号或独立的 Unknowns 章节兜底，分层颗粒比 Codex 粗。
- §6 期望结果直接写"勾选后，report 中能展示该客户「発着信履歴」中最新一条对应的 `発着信時間`"，未在该节同时显式提示"最新"口径仍待 §9 确认；虽然 AC 那一侧绑定了 Unknowns #3，期望结果一节里没绑定，孤立看会让读者误读为已确认结论。
- §7 In Scope 第 4 条"勾选该项目后，report 中能够展示该客户最新一条発着信履歴的 `発着信時間`"也存在与 §6 相同的措辞偏紧问题。

### 可吸收内容
- §10 AC 编号体系（AC-XXX + AC-Regression-XXX）。
- §11 关于 `/admin/cdr/index` `id DESC` 与 `start_date DESC` 不等价的歧义。
- §9 末尾"禁止脑补回答"的硬性约束写法。
- §12 关于"代码调查报告只能作后续阶段参考"的写法。

---

## 4. Candidate C: DeepSeek 评价

### 优点
- §11 用表格形式列出风险（含影响 / 深刻度），可读性较好。
- §9 Unknowns 中对"最新"两种候选口径（`Cdr.start_date MAX` vs `customer_notes.id MAX`）有清晰表述。
- §12 后续提醒数量最多，覆盖了最新判定、集計可选性、无数据表示、CSV/API、多语言、迁移、权限、测试数据等。

### 问题（关键违规点，必须指出）

1. **把 Unknown 写成了已确认事实（违反硬性要求）**：
   - §7 In Scope 直接写："**対象レポートタイプ: 表形式レポート（`type=1`）**"——这本应在 Unknowns 中保留，DeepSeek 在自己的 §9 里也确实把它当成 Unknown 列出，但 §7 又自相矛盾地写成了 In Scope 的确认事项。
   - §7 In Scope 写："顧客ごとに発着信履歴（cdr）の `start_date` が最大となるレコードを参照し、その `start_date` を表示する"——虽然括号加了"※口径は要確認、後述"，但**仍然把"最新 = `Cdr.start_date` 最大值"写进了 In Scope 的数据取得逻辑**，这正是任务说明里点名要警告的越界。
   - §7 In Scope 写："**レポート出力対応：表形式レポートの CSV ダウンロード**"——CSV 是否纳入本次范围在 §9 Unknown #5 中明确标为未知，但 §7 又写成了 In Scope。

2. **把 Unknown 写成 Out of Scope（同样越界）**：
   - §8 Out of Scope 写："**集計レポート（`type=2`）への対応（現時点では要件に含めない）**"——用户补充原话明确写了"* 表形式レポート / * 集計レポート"，是否纳入集計是 Unknown，不应在 M1 阶段直接划入 Out of Scope。
   - §8 Out of Scope 写："**API `api_find_report` の改修（必要かどうか未確認のため、意図的なスコープ外）**"——"未確認所以意図的スコープ外"在逻辑上是把 Unknown 当成 Out of Scope 处理，属于 M1 阶段不可接受的范围决断。

3. **混入实现方案（违反硬性要求）**：
   - §7 写："**システムフィールドとして `発着信日時（最新）` を定義**"——这是实现指令。
   - §7 写："**日本語ロケールのプロパティファイルに `発着信日時（最新）` を追加**"——具体到 i18n 文件级别的实现细节。
   - §12 写："**実装時に `num` の割り振り方を指示する**"——直接指向具体字段编号字段。
   - §12 写："**`ApplicationResources.properties` に加え、他言語（英語、中国語など）のリソースファイルにも同様のキーを定義**"——具体到文件名和键定义。
   - §12 写："**`privilege.conf` にレポートダウンロード用の未使用アクションが存在するため、今回の対応で混入させないよう注意する**"——这是代码调查结论被直接搬进需求卡。
   - §4 操作路径写到了"レポート編集: `admin/customer_contact_history_reports/edit`、レポート表示: 表形式レポート詳細画面"——这两个 URL/画面属于代码调查得到的结论，作为本阶段的"已确认操作路径"超出了领导原话给出的范围。

4. **"最新"口径风险处理矛盾**：
   §11 R1 已经清晰指出"最新口径不一致"是高风险，但 §7 In Scope 仍把 `start_date MAX` 写进数据取得逻辑，自相矛盾。这就是任务说明里要求必须指出的"把'最新 = Cdr.start_date 最大值'直接当成确定事实"的典型情形（虽然加了"※要確認"的括注，但写进 In Scope 数据逻辑本身就是越界）。

5. **AC-8 写法依赖于自己越界的 In Scope**：
   AC-8 "CSV ダウンロード（スコープに含む場合）"——CSV 是否纳入本身就是 Unknown，AC 不该单独成项，应像 Claude 那样把它与 Unknowns 显式绑定。

### 可吸收内容
- §11 的"风险表 + 影响 + 深刻度"表格形式可作为风险章节的展示模板。
- §12 关于"测试数据准备：同一顾客多条 cdr 不同 start_date"作为后续阶段的提醒，可吸收一句。
- §9 Unknown #2 中对"最新"两种候选口径的措辞较直白，可作为表达参考。

**不可吸收**：§7 In Scope、§8 Out of Scope 的写法，§4 操作路径中的画面级断言，以及 §12 中所有指向具体文件/字段/属性的实现细节。

---

## 5. 横向对比表

| 维度 | Codex | Claude | DeepSeek |
|---|---|---|---|
| 1. 是否保留领导原话 | ✓ 完整保留含引文区块 | ✓ 完整保留含引文区块 | ✓ 完整保留含引文区块 |
| 2. 是否准确识别主目标 | ✓ | ✓ | ✓ |
| 3. 是否区分 已确认 / 推测 / 未知 | ✓ 章节内显式三层分层 | △ 主要靠 Unknowns 章节兜底，节内未显式三层 | ✗ 多处把 Unknown 写成已确认 In Scope 或 Out of Scope |
| 4. 表形式/集計范围差异处理 | ✓ 保留为待确认范围 | ✓ Unknowns #1/#2 显式保留 | ✗ §8 把集計直接划入 Out of Scope |
| 5. "最新"口径风险保留 | ✓ §6 / §9 / §11 三处均保留为未确认 | ✓ Unknowns #3 + §11 风险均保留 | △ §11 指出但 §7 In Scope 把 `start_date MAX` 写进数据逻辑，矛盾 |
| 6. 是否没有进入实现方案 | ✓ 完全没有 | ✓ 完全没有 | ✗ 混入 i18n property / privilege.conf / num 分配 / 系统字段定义等 |
| 7. AC 是否可手动验证 | ✓ 全部可手动 | ✓ 全部可手动，且编号体系最规整 | ✓ 基本可手动 |
| 8. Unknowns 是否完整 | ✓ 10 条，覆盖最广 | ✓ 8 条且明确"禁止脑补" | △ 7 条，部分本应 Unknown 的项被自己写进了 In/Out of Scope |
| 9. 风险与歧义是否充分 | ✓ 高风险/歧义/过程风险三层 | ✓ 含 `id DESC` vs `start_date DESC` 等独有细节 | ✓ 表格形式直观，但与 §7 矛盾 |
| 10. 是否适合作为后续 frozen 基础 | ✓ 最适合 | ○ 适合，需在 §6/§7 削紧"最新"措辞 | ✗ 需大量返工：清理实现方案、撤回 In/Out of Scope 中的越界判定 |

---

## 6. 关键风险保留情况

| 关键风险 | Codex | Claude | DeepSeek |
|---|---|---|---|
| "最新 = `Cdr.start_date` 最大值" 是否被当成确定事实 | 否（明确列出两种候选，未选择） | 否（Unknown #3 显式保留） | **是**——§7 In Scope 数据逻辑中直接采用 `start_date` MAX 写法，仅加括注"要確認"，违反硬性要求 |
| 集計レポート范围是否被忽略或预设 | 否（保留为待确认范围） | 否（Unknown #2 显式保留） | **是**——§8 直接划入 Out of Scope，与用户补充原话中"* 集計レポート"冲突 |
| CSV / 表形式 CSV / 集計 CSV / API 范围是否保留为未知 | 否，三者均明确"未确认" | 否，Unknowns #6 / #7 明确保留 | **是**——§7 把 CSV 写进 In Scope；§8 把 API 写进 Out of Scope（理由是"未確認"） |
| 是否混入实现方案 | 否 | 否 | **是**——property file、num 分配、system field 定义、privilege.conf 等 |
| 是否把 Unknown 升级为已确认事实 | 否 | 否 | **是**——表形式 type=1、CSV、集計剔除、最新口径等多处 |

---

## 7. 推荐主卡

**推荐采用 Candidate A: Codex 作为主卡。**

理由：
1. 唯一一张在章节级别（而非仅在 Unknowns 章节）严格执行"已确认 / 推测 / 未知"三层分类的卡片，与 M1 阶段"严禁脑补、严禁把 Unknown 升级为事实"的原则最契合。
2. 对集計レポート / 表形式 CSV / 集計 CSV / api_find_report / "最新"口径五项关键 Unknown，均未在 In Scope / Out of Scope 中做任何范围决断，全部保留为"待确认范围"。
3. §12 明确警告"代码调查中的'可能相关文件 / 最小修改候选范围'不能直接转写为'必须修改文件'"，对后续 Engineering Requirement Card 阶段的越界做了预防性约束。
4. 完全没有实现方案 / SQL / property file / 字段编号 / 权限文件级别的细节。

Claude 作为次优，可在 Codex 基础上吸收其 AC 编号体系、回归项写法、`id DESC` vs `start_date DESC` 的细节歧义、"禁止脑补回答"的硬性声明。

DeepSeek 不可作为主卡基础，需先剥离越界部分后才能局部吸收。

---

## 8. 合并建议

以 Codex 为骨架，按以下方式合并：

1. **保留 Codex §1～§9 的整体结构与三层分层**（已确认 / 推测 / 未知）。

2. **AC 章节改用 Claude §10 的编号体系**：
   - AC-001、AC-002…的正向项
   - AC-Regression-001、AC-Regression-002…的回归项
   - 每个含范围依赖的 AC（如 CSV / 集計 / 最新口径）显式绑定 Unknown 编号，写为"以 Unknowns #X 确认结果为准"。

3. **§11 风险章节**：
   - 主体保留 Codex 现有的"高风险 / 歧义 / 过程风险"分层叙述。
   - 增加 Claude §11 中"`/admin/cdr/index` 默认 `id DESC` 并非 `start_date DESC`，'视觉最新'与严格最大值不天然等价"一条。
   - 可参考 DeepSeek §11 的表格视觉形式（但只采用表格形态，不采用其内容矛盾的措辞）。

4. **§9 Unknowns 末尾**追加 Claude 的硬性声明："以上 Unknowns 必须保留，禁止在本卡片中替领导脑补回答。"

5. **§12 后续提醒**：
   - 保留 Codex 现有内容（含"代码调查报告只能作参考"的核心警告）。
   - 追加 Claude §12 中"本卡片所有保留的 Unknowns 与风险，必须在 Engineering Requirement Card 中逐项给出处置方式（确认 / 推迟 / 排除范围）"。
   - 可从 DeepSeek §12 中**仅**吸收一句："最新発着信判定の検証用に、同一顧客に `start_date` の異なる複数の cdr を用意するテストデータが必要"，作为后续阶段的提醒，但**不要**搬入 DeepSeek 关于 property file、`num` 分配、`privilege.conf`、`ApplicationResources.properties` 等任何实现层级的提醒。

6. **明确不吸收的内容**：
   - DeepSeek §7 In Scope 中的所有具体实现指令（system field 定义、property file 添加、CSV ダウンロード対応等）。
   - DeepSeek §8 Out of Scope 中对集計レポート、`api_find_report` 的范围决断。
   - DeepSeek §4 中"レポート編集: `admin/customer_contact_history_reports/edit`、レポート表示: 表形式レポート詳細画面"等代码调查层级的"已确认操作路径"扩展。
   - DeepSeek §12 中所有指向具体文件名 / 字段名 / 权限文件的提醒。

合并后产出的 frozen requirement card 应仍保持：**在所有"最新"口径、表形式/集計/CSV/API 范围、順番"最后一位"判定基准、无数据显示规则、命名一致性**等关键点上不替业务方下结论，仅保留 Unknowns 待后续确认。

---

## Round 1 Score

{
  "round": "round-1",
  "scores": {
    "codex": {
      "fidelity_to_original_request": 10,
      "requirement_clarity": 10,
      "scope_control": 10,
      "unknowns_quality": 10,
      "risk_detection": 10,
      "acceptance_criteria_quality": 9,
      "no_implementation_leakage": 10,
      "usefulness_for_next_stage": 10,
      "total": 79,
      "summary": "唯一在章节级别严格执行‘已确认/推测/未知’三层分类，关键Unknown均未在In/Out Scope中越界决断，完全没有实现方案泄漏，AC可手动验证但编号体系稍弱。最适合作为frozen基础。"
    },
    "claude": {
      "fidelity_to_original_request": 10,
      "requirement_clarity": 9,
      "scope_control": 8,
      "unknowns_quality": 9,
      "risk_detection": 10,
      "acceptance_criteria_quality": 10,
      "no_implementation_leakage": 10,
      "usefulness_for_next_stage": 9,
      "total": 75,
      "summary": "原话保真，AC编号与回归项最规整，风险识别细腻；但章节内未显式三层分层，期望结果措辞偏紧，易被误读为已确认，需微调。整体适合作为辅助参考。"
    },
    "deepseek": {
      "fidelity_to_original_request": 8,
      "requirement_clarity": 7,
      "scope_control": 2,
      "unknowns_quality": 4,
      "risk_detection": 9,
      "acceptance_criteria_quality": 6,
      "no_implementation_leakage": 1,
      "usefulness_for_next_stage": 3,
      "total": 40,
      "summary": "严重越界，把集計、CSV、最新口径等Unknown写成In/Out Scope事实，混入大量实现方案，AC依赖自身越界的范围。风险表格形式可取其形，不可取其内容。"
    }
  },
  "winner": "codex",
  "merge_policy": {
    "base_candidate": "codex",
    "absorb_from_codex": [],
    "absorb_from_claude": [
      "AC编号体系与回归项写法（AC-001…, AC-Regression-001…）",
      "id DESC vs start_date DESC 歧义及参考画面风险点",
      "§9 末尾‘禁止在本卡片中替领导脑补回答’硬性声明",
      "§12 后续提醒中‘所有Unknowns与风险必须在Engineering Requirement Card中逐项给出处置方式’"
    ],
    "absorb_from_deepseek": [
      "风险表格展示形式（仅表格形态，不采用其内容矛盾措辞）",
      "测试数据提醒：同一顾客多条cdr不同start_date的验证用测试数据"
    ],
    "discard": [
      "deepseek_in_scope_all_scope_decisions",
      "deepseek_out_of_scope_unconfirmed_items",
      "deepseek_implementation_details",
      "deepseek_code_survey_expanded_operation_paths",
      "deepseek_privilege_conf_and_resource_files",
      "deepseek_num_assignment_and_system_field_definition"
    ]
  }
}

---

## Original Material Package

# 00-material-package

## Purpose

This material package is the single source of input for M1 Requirement Card draw.

The current stage is M1 Requirement Card only.

Do not generate:
- Engineering Requirement Card
- implementation plan
- code
- SQL
- patch
- diff

The goal is to generate Requirement Card Candidates, compare them, score them, decide the best one, merge useful points, and finally produce a frozen Requirement Card.

---

## Input 1: 沉淀物-1 Task Clarification Brief

# 沉淀物-1:Task Clarification Brief (Quick)

* task_id: `20260513-customer-report-latest-call-datetime`
* mode: Quick
* mode_reason: 用户明确要求改为 Quick；当前已有领导原话、目标页面、追加项目名、参考页面和验证方式，先按快档沉淀给代码调查 Agent。
* investigation_readiness: ready
* created_at: 2026-05-13

---

## 1. 原始需求（保真）

```text
"【① 顧客情報レポートについて】
「顧客最新情報」においても発信日付を表示できるようしたい
※現状は「顧客対応履歴」から全履歴を確認いただき、最新の発信日付を抽出いただく必要がございます。"

ベルシステム２４
```

用户补充原话 / 线索：

```text
発着信日時（最新）→ 発着信履歴に一番最新→ cdr参照

* 表形式レポート
* 集計レポート
```

---

## 2. 一句话摘要

在 `admin/customer_contact_history_reports/add` 页面中的 `項目（*必須）` 里追加一个可选择项目：`発着信日時（最新）`，用于在 report 中显示该客户最新一条発着信履歴的 `発着信時間`。

---

## 3. 主画面 + 改动点

* 主画面 / 报表：`admin/customer_contact_history_reports/add`
* 区块 / 位置：`項目（*必須）`
* 输出形式：report

  * 已确认：页面配置项需要追加
  * 已确认：勾选后 report 中需要展示
  * 需代码调查确认：是否同时影响 `表形式レポート` 和 `集計レポート`
* 用户操作路径：

  * 未知：完整菜单路径未确认
  * 已确认：目标页面 URL 为 `admin/customer_contact_history_reports/add`
* 改动点：

  * 在 `項目（*必須）` 中追加 `発着信日時（最新）`
  * `項目（*必須）` 当前有三列：

    * `出力 項目名`
    * `表示名`
    * `順番`
  * `発着信日時（最新）` 需要显示在：

    * `出力 項目名` 列
    * `表示名` 列
  * `順番` 放在最后一位

---

## 4. 现状 vs 期望

| 维度        | 现状                               | 期望                           |
| --------- | -------------------------------- | ---------------------------- |
| 显示内容      | 页面初始化时，`項目（*必須）` 中没有 `発着信日時（最新）` | `項目（*必須）` 中出现 `発着信日時（最新）`    |
| 显示位置      | 未显示                              | 显示在 `出力 項目名` 列和 `表示名` 列      |
| 显示格式      | 未知                               | 显示名为 `発着信日時（最新）`             |
| 用户操作      | 当前无法勾选该项目                        | 可以勾选该项目                      |
| report 输出 | 当前 report 中无法通过该项目展示最新発着信日時      | 勾选后 report 中可以展示 `発着信日時（最新）` |
| 顺番        | 当前不存在该项顺番                        | 按顺序放在最后一位                    |
| 无数据时      | 未知                               | 需代码调查确认                      |
| 多条数据时     | 需要用户从「顧客対応履歴」全履历中自行确认最新发信日付      | 取発着信履歴中最新一条的 `発着信時間`         |

---

## 5. 影响范围 checklist

| 项目                 | Y / N / ? | 说明                                                             |
| ------------------ | --------: | -------------------------------------------------------------- |
| 画面显示               |         Y | `admin/customer_contact_history_reports/add` 的 `項目（*必須）` 要追加项目 |
| CSV 下载             |         ? | 未确认 report 是否有 CSV 下载或是否受同一配置影响                                |
| Excel / PDF 输出     |         ? | 未确认是否存在 Excel / PDF 输出                                         |
| 定时任务(batch / cron) |         ? | 未确认是否存在定时 report 生成                                            |
| 邮件内容               |         ? | 未确认是否存在邮件配信内容受影响                                               |
| 搜索条件               |         N | 当前需求没有提到搜索条件                                                   |
| 排序规则               |         ? | `順番` 放最后已确认，但最新発着信履歴的排序基准需代码调查确认                               |
| 权限控制               |         N | 当前需求没有提到权限控制                                                   |
| 多个类似页面一致性          |         ? | `/admin/cdr/index` 是参考页面；其他类似页面是否需要一致需代码调查确认                   |
| API 返回值            |         ? | 未确认该页面 / report 是否通过 API 返回数据                                  |

---

## 6. 数据来源线索（全部为推测，需代码调查验证）

* 领导关键词：

  * `顧客情報レポート`
  * `顧客最新情報`
  * `発信日付`
  * `顧客対応履歴`
  * `最新の発信日付`
* 用户补充关键词：

  * `発着信日時（最新）`
  * `発着信履歴`
  * `cdr参照`
  * `表形式レポート`
  * `集計レポート`
* 可能相关画面：

  * 已确认目标页面：`admin/customer_contact_history_reports/add`
  * 已确认参考页面：`/admin/cdr/index`
* 可能相关表 / 字段：

  * 推测：cdr 相关表
  * 推测：発着信履歴相关数据
  * 推测：`発着信時間` 相关字段
* 可能可复用的既存逻辑：

  * `/admin/cdr/index` 页面中展示最新一条记录的 `発着信時間` 的逻辑
* 需代码调查确认：

  * `/admin/cdr/index` 的实际 controller / model / table / 字段名
  * 最新一条记录的判断是否以 `発着信時間` 降序为准
  * `表形式レポート` 和 `集計レポート` 是否都通过 `admin/customer_contact_history_reports/add` 的项目配置控制
  * report 输出侧如何根据勾选项目取值

---

## 7. 验收场景

* AC-001：部署后访问 `admin/customer_contact_history_reports/add`，确认 `項目（*必須）` 中出现 `発着信日時（最新）`。
* AC-002：确认 `発着信日時（最新）` 可以被勾选。
* AC-003：勾选 `発着信日時（最新）` 后生成 / 查看 report，确认 report 中可以展示 `発着信日時（最新）`。
* AC-004：存在多条発着信履歴时，report 中展示的是最新一条记录对应的 `発着信時間`。
* AC-Regression-001：未勾选 `発着信日時（最新）` 时，既存 report 的其他项目显示不受影响。
* AC-Regression-002：既存 `項目（*必須）` 中原有项目的显示名、顺番、勾选行为不受影响。

---

## 8. 仍不明确的问题

1. `表形式レポート` 和 `集計レポート` 是否都由 `admin/customer_contact_history_reports/add` 的 `項目（*必須）` 控制。
2. `発着信日時（最新）` 在无発着信履歴数据时应该显示为空、`-`，还是其他默认值。
3. 最新一条発着信履歴的判断基准是否就是 `/admin/cdr/index` 中的 `発着信時間` 最新。
4. report 输出侧是否包含 CSV / Excel / PDF / 定时任务 / 邮件配信等派生输出。
5. `/admin/cdr/index` 中 `発着信時間` 的实际数据来源、字段名、关联条件需要代码调查确认。
6. `顧客最新情報` 与 `顧客情報レポート`、`顧客対応履歴`、`cdr` 之间的代码关联关系需要代码调查确认。

---

## 9. 给代码调查 Agent 的 Prompt

你是既存项目代码调查 Agent。请基于以下 Brief 在项目中调查相关代码。

目标需求：

```text
在 admin/customer_contact_history_reports/add 页面中的 項目（*必須） 中追加一个项目：
発着信日時（最新）

该项目需要显示在：
- 出力 項目名
- 表示名

順番放在最后一位。

参考页面：
/admin/cdr/index

参考字段：
発着信時間

目标含义：
取该客户発着信履歴中最新一条记录的 発着信時間，并在 report 中作为 発着信日時（最新） 展示。
```

请优先调查：

1. `admin/customer_contact_history_reports/add` 页面对应的 controller / view / model / service。
2. `項目（*必須）` 的项目列表是在哪里定义、初始化、保存和读取的。
3. report 输出时，勾选项目如何映射到实际数据。
4. `/admin/cdr/index` 中 `発着信時間` 的数据来源、关联条件和排序逻辑。
5. `表形式レポート` 和 `集計レポート` 是否都受这次追加项目影响。
6. 是否存在 CSV / Excel / PDF / batch / cron / 邮件配信等派生输出。
7. 无発着信履歴数据时，既存类似字段如何显示。
8. 是否有既存字段追加模式可以参考。

[只读边界 — 必须遵守]

1. 你是 read-only Agent。只能阅读代码，不能修改任何文件。
2. 不能生成 patch / diff。
3. 不能执行 migration 脚本。
4. 不能连接服务器，包括 dev / staging / production。
5. 不能直接查询任何数据库。
6. 如需数据库结构或数据样本，只能生成 SQL / shell 命令，由用户自行执行后贴回结果。
7. 如涉及 `.env` / 密钥配置 / 生产配置，只列出路径，不读取内容。
8. 所有结论三态分明：代码中已确认 / 根据命名推测 / 仍需用户确认。
9. 不允许把“可能相关文件”写成“必须修改文件”。
10. 不允许给出实现方案。你的任务是定位与判断，不是设计与实现。

请输出「报告-1:Code Investigation Report」，至少包含：

* 相关文件清单
* 调用链
* 数据来源验证
* `admin/customer_contact_history_reports/add` 中 `項目（*必須）` 的生成逻辑
* report 输出时项目映射逻辑
* `/admin/cdr/index` 中 `発着信時間` 的来源与排序逻辑
* 影响范围逐项判断，对应 Brief Section 5 的 checklist
* 最小修改候选范围
* 风险点
* 仍需人工确认的问题

---

## Input 2: 报告-1 Code Investigation Report

# 报告-1: Code Investigation Report

## 1. 调查结论摘要
- `admin/customer_contact_history_reports/add` 的「項目（*必須）」由 controller 内系统字段数组 + 自定义字段数组生成；页面本身不硬编码具体业务字段。参考 [customer_contact_history_reports_controller.php#L112](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L112), [admin_add.thtml#L81](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml#L81)。
- 当前 `target=2（顧客最新情報）` 的系统字段列表里没有 `Cdr.start_date`；`target=1（顧客対応履歴）` 才有。参考 [customer_contact_history_reports_controller.php#L198](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L198), [customer_contact_history_reports_controller.php#L128](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L128)。
- 报表输出字段来自 `CustomerContactHistoryReportField`（保存的勾选字段），并在列表展示/API/CSV下载时按 `field_name` 映射取值。参考 [customer_contact_history_reports_controller.php#L314](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L314), [customer_contact_history_reports_controller.php#L617](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L617), [customer_contact_history_reports_controller.php#L1656](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1656)。
- `target=2` 的“最新信息”当前是通过“每个客户取 `customer_notes` 最大 `id`”来关联最新 note，再 left join 到 cdr，并非按 `Cdr.start_date` 取最新。参考 [customer_contact_history_reports_controller.php#L704](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L704)。
- `/admin/cdr/index` 的「発着信時間」就是 `cdr.start_date` 字段。参考 [cdr_controller.php#L690](/Users/palm/bluebean/callcenter/app/controllers/cdr_controller.php#L690), [ApplicationResources.properties#L1445](/Users/palm/bluebean/callcenter/app/locale/ja/ApplicationResources.properties#L1445)。
- 业务口径“最新発着信日時”通常期望按 `Cdr.start_date DESC`，但现有“顧客最新情報”链路口径是“最新 note(id)”。两者可能不一致。
- 新增项是否只要求“表形式レポート（type=1）”可选，还是“集計レポート（type=2）”也要可选。

## 2. 相关文件清单
- 入口与核心逻辑  
[customer_contact_history_reports_controller.php](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php)  
[customer_contact_history_report.php](/Users/palm/bluebean/callcenter/app/models/customer_contact_history_report.php)  
[customer_contact_history_report_field.php](/Users/palm/bluebean/callcenter/app/models/customer_contact_history_report_field.php)
- 新建/编辑/查看页面  
[admin_add.thtml](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml)  
[admin_edit.thtml](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_edit.thtml)  
[admin_view.thtml](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_view.thtml)
- 报表输出页面与JS  
[admin_report_detail_view.thtml](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_report_detail_view.thtml)  
[admin_report_detail_view_matrix.thtml](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_report_detail_view_matrix.thtml)  
[add.js](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/customer_contact_history_reports/add.js)  
[edit.js](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/customer_contact_history_reports/edit.js)  
[report_detail_view.js](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/customer_contact_history_reports/report_detail_view.js)
- CDR 参考页  
[cdr_controller.php](/Users/palm/bluebean/callcenter/app/controllers/cdr_controller.php)  
[admin_index.thtml](/Users/palm/bluebean/callcenter/app/views/cdr/admin_index.thtml)  
[index.js](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/cdr/index.js)  
[search_for_cdr_list.js](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/cdr/search_for_cdr_list.js)
- 文案与权限  
[ApplicationResources.properties(ja)](/Users/palm/bluebean/callcenter/app/locale/ja/ApplicationResources.properties)  
[CustomerContactHistoryReports.properties](/Users/palm/bluebean/callcenter/app/locale/ja/tooltip/CustomerContactHistoryReports.properties)  
[privilege.conf](/Users/palm/bluebean/callcenter/app/config/privilege.conf)

## 3. 调用链
- 配置页字段生成链  
`admin_add/admin_edit` → `__setFormData()` 组装 `tableSystemFields/matrixSystemFields` → view 渲染「項目（*必須）」。
- 字段保存链  
提交表单 `data[fields...]` + `fields_cheched_index` → `__addReport/__editReport` → `customer_contact_history_report_fields`。
- 报表输出链（表形式）  
`admin_report_detail_view`（页面）→ `admin_report_detail_list_view_get`（DataTables JSON）→ `__downloadReportDetail`（CSV）。
- 报表输出链（集計）  
`admin_report_detail_view` matrix 分支 → `admin_report_detail_view_matrix` → `__downloadMatrixTable`（CSV）。
- CDR参考链  
`/admin/cdr/index` → `admin_index_get` 读 `cdr` 表 `start_date`。

## 4. admin/customer_contact_history_reports/add 中 項目（*必須） 的生成逻辑
- 字段源头在 `__setFormData()` 内按 `target` 分支构建。`target=1` 包含 `Cdr.start_date`，`target=2` 不包含。见 [customer_contact_history_reports_controller.php#L124](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L124), [customer_contact_history_reports_controller.php#L198](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L198)。
- 页面“出力/項目名/表示名/順番”四列由 `tableSystemFields` 循环渲染。见 [admin_add.thtml#L87](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml#L87)。
- 顺番默认值来自 `$num` 递增，显示顺序即数组顺序；“放最后”依赖字段被追加在数组尾部。见 [admin_add.thtml#L105](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml#L105)。
- `campaign/target` 变化会自动提交并重建字段列表。见 [add.js#L3](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/customer_contact_history_reports/add.js#L3)。

## 5. report 输出时项目映射逻辑
- 勾选字段保存后，输出时取 `CustomerContactHistoryReportField.field_name` 做映射。见 [customer_contact_history_reports_controller.php#L617](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L617), [customer_contact_history_reports_controller.php#L1656](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1656)。
- 表形式 target=2 查询使用 `customer_contacts` + “每客户最新 note(max id)” + `cdr`。见 [customer_contact_history_reports_controller.php#L700](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L700)。
- 前端列表列名来自保存字段名，数据键为 `model_field`。见 [admin_report_detail_view.thtml#L170](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_report_detail_view.thtml#L170), [report_detail_view.js#L64](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/customer_contact_history_reports/report_detail_view.js#L64)。
- CSV标题取字段 `name`（显示名），不是 `field_name`。见 [customer_contact_history_reports_controller.php#L1612](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1612)。
- 无值时多数分支输出空字符串；部分枚举输出 `N/A` 或 `global.blank`。见 [customer_contact_history_reports_controller.php#L1666](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1666), [customer_contact_history_reports_controller.php#L1736](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1736), [ApplicationResources.properties#L288](/Users/palm/bluebean/callcenter/app/locale/ja/ApplicationResources.properties#L288)。

## 6. /admin/cdr/index 中 発着信時間 的来源与排序逻辑
- 字段来源：`cdr.start_date`。见 [cdr_controller.php#L690](/Users/palm/bluebean/callcenter/app/controllers/cdr_controller.php#L690), [ApplicationResources.properties#L1445](/Users/palm/bluebean/callcenter/app/locale/ja/ApplicationResources.properties#L1445)。
- 页面默认排序是第1列（id）降序（前后端都写了默认）。见 [cdr_controller.php#L61](/Users/palm/bluebean/callcenter/app/controllers/cdr_controller.php#L61), [index.js#L38](/Users/palm/bluebean/callcenter/app/webroot/js/new_admin/cdr/index.js#L38)。
- 配置 `CDR_SORT=0` 时强制允许第1列排序，当前环境配置文件也为 0。见 [cdr_controller.php#L77](/Users/palm/bluebean/callcenter/app/controllers/cdr_controller.php#L77), [sctel.conf#L325](/Users/palm/bluebean/callcenter/app/config/sctel.conf#L325)。
- 在大多数数据下 `id DESC` 与“最新発着信時間”接近，但不等于严格按 `start_date DESC`。

## 7. 表形式レポート / 集計レポート 影响判断
- `項目（*必須）` 仅在表形式（type=1）显示；集計使用 X/Y/V 下拉。见 [admin_add.thtml#L81](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml#L81), [admin_add.thtml#L159](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml#L159)。
- 如果只补到 `tableSystemFields`，直接影响表形式；不自动影响集計下拉。
- target=2 的集計 SQL 当前没有 join `cdr`，若将 CDR 字段引入集計口径会产生额外影响面。见 [customer_contact_history_reports_controller.php#L823](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L823)。
- 需求是否要求集計也支持“発着信日時（最新）”。

## 8. 派生输出影响判断：CSV / Excel / PDF / batch / cron / 邮件 / API
- CSV  
有两类 CSV：表形式 `__downloadReportDetail`、集計 `__downloadMatrixTable`，字段新增会影响对应CSV列。见 [customer_contact_history_reports_controller.php#L1580](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1580), [customer_contact_history_reports_controller.php#L1486](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1486)。
- Excel/PDF  
在该 controller 未发现 Excel/PDF 输出实现。
- batch/cron  
未发现与 `CustomerContactHistoryReport` 直接关联的 shell/cron 调用链。
- 邮件  
未发现该报表输出直连邮件配信。
- API  
存在 `api_find_report`/`api_update_contact`；`api_find_report` 也是基于已配置字段输出CSV。见 [customer_contact_history_reports_controller.php#L1791](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php#L1791)。
- 补充  
`privilege.conf` 有 `admin_report_detail_download` 权限项，但 controller 未实现同名 action。见 [privilege.conf#L121](/Users/palm/bluebean/callcenter/app/config/privilege.conf#L121)。

## 9. 最小修改候选范围
- 字段定义源  
[customer_contact_history_reports_controller.php](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php)
- 新建/编辑页面字段表渲染  
[admin_add.thtml](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_add.thtml)  
[admin_edit.thtml](/Users/palm/bluebean/callcenter/app/views/customer_contact_history_reports/admin_edit.thtml)
- 报表查询与下载映射（table/matrix/API）  
[customer_contact_history_reports_controller.php](/Users/palm/bluebean/callcenter/app/controllers/customer_contact_history_reports_controller.php)
- 多语言文案  
[ApplicationResources.properties(ja)](/Users/palm/bluebean/callcenter/app/locale/ja/ApplicationResources.properties) 及其他语言包

## 10. 风险点
- “顧客最新情報”当前“最新”定义是 `customer_notes.max(id)`，不是 `cdr.start_date max`，存在业务口径偏差风险。
- target=2 集計查询未 join cdr；若需求扩到集計会引出SQL层影响。
- 无 cdr/无 note 的展示在不同路径有空串/`(空白)`/`N/A` 多种表现，需统一预期。
- 若以 `/admin/cdr/index` 的视觉“最新”作为标准，当前默认排序偏向 `id DESC`，需确认是否可接受。
- 权限里存在未实现 action 项，历史遗留配置可能造成误判范围。

## 11. 仍需人工确认的问题
- `発着信日時（最新）` 的“最新”判定口径是否明确为 `Cdr.start_date` 最大值，而不是最新 `customer_notes.id`？
- 仅要求 `target=2 + type=1`，还是 `type=2`（集計）也要可选/可统计？
- 无発着信履歴时目标显示是否统一为空字符串、`（空白）` 还是 `-`？
- 顺番“最后一位”是指仅系统字段最后，还是包含自定义 `CustomerContactExt.field*` 后的全列表最后？
- 需要同步到 `api_find_report` 的对外行为吗（尤其 report 为 target=2 时）？