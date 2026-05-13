# Round 1 Candidate Comparison

## 1. 总体结论

三张 Candidate 都正确保留了领导原话与用户补充原话，整体方向一致：都识别出「在 `admin/customer_contact_history_reports/add` 的 `項目（*必須）` 中追加 `発着信日時（最新）`」这一主目标；都识别到“最新”口径风险与代码现状中 `customer_notes.max(id)` ≠ `Cdr.start_date` 的偏差。

差异主要在“需求纯度”：

- **Codex (A)**：最纯净的需求卡。所有范围未确认项（集計 / CSV / API / 表形式 CSV / 集計 CSV）都明确放在 Unknowns，不在 In Scope / Out of Scope 中提前定版，是三张中“最克制”的一张。
- **Claude (B)**：结构最完整，已确认 / 推测 / 未知 分层清晰，Unknowns 编号、AC 编号、Regression AC 都有，且明确指出 CSV / 集計 / API 范围未确认而放进 Unknowns。
- **DeepSeek (C)**：信息量最大，但出现了较严重的“需求纯度”问题：一方面把「集計レポート不在范围内」写进 Out of Scope（与自己 Unknowns 第 2 条直接矛盾），另一方面混入了字段命名建议 (`cdr_latest_start_date`)、SQL 实现策略（lateral join / 窗口函数）、性能设计要求、i18n 实现建议等——这些都属于工程卡范畴。

推荐主卡：**Claude (B)**，吸收 Codex (A) 的克制度与 DeepSeek (C) 的部分细节（如多语言、列宽筛选等点可作为补充 Unknown）。

---

## 2. Candidate A: Codex 评价

### 优点
- 领导原话与用户补充原话完整、原样保留。
- 一句话需求摘要明确指出“是否同时覆盖 `集計レポート` 仍未确认”，没有提前定版。
- 所有「已确认 / 推测 / 未知」标记非常严格,每一条都标注来源属性。
- 明确指出现有 `顧客最新情報` 链路的“最新”实际是 `customer_notes.id` 最大值,不是 `cdr.start_date` 最大值,口径风险保留得最干净。
- `/admin/cdr/index` 默认按 `id DESC` 排序不严格等同 `start_date DESC` 这一隐性偏差也被明确记录。
- `表形式レポート` vs `集計レポート` 的范围差异显式列入风险与 Unknowns,未提前判定。
- CSV / API / 表形式 CSV / 集計 CSV 全部进入 Unknowns,没有任何一处被升级为「必须一起改」。
- 完全没有实现细节,没有 SQL,没有字段命名建议。
- 在 §12 明确告知后续工程卡:不能把代码调查升级为实现指令。
- 显式记录了「発信 vs 発着信」「日付 vs 日時」的歧义。

### 问题
- AC 编号略粗(AC-01 ~ AC-08),AC-07 / AC-08 用条件式描述「若后续确认」,执行时仍需依赖未来决定,可读性上不如 Claude 的 Regression AC 分组清晰。
- 缺少对“编辑页 / 查看页”(admin_edit / admin_view)同步行为的明确化,只在 Claude 的版本中显式覆盖。
- 没有列出多语言 / 列宽 / 筛选等次级 Unknown。

### 可吸收内容
- “代码调查只能作为需求澄清依据,不能直接跳成实现指令”这条 §12 的提醒措辞非常好,建议合并卡保留。
- “顺番最后一位”边界(系统字段 vs 包含自定义字段)的提问保留。
- “発信 vs 発着信 / 日付 vs 日時”的歧义说明保留。

---

## 3. Candidate B: Claude 评价

### 优点
- 整体结构最完整,有 AC + Regression AC + Unknowns 编号交叉引用(AC-007 引用 Unknown 4 等),便于后续按需求版本管理。
- 准确指出 `target=2` 的“最新”当前是 `customer_notes.max(id)` 关联,不是 `cdr.start_date`,口径风险保留正确。
- 明确指出 `項目（*必須）` 区块只在表形式 type=1 显示,集計 type=2 用 X/Y/V 下拉,且 target=2 集計 SQL 当前未 join cdr——把范围风险写进了风险条目而不是直接定版。
- CSV / 集計 / `api_find_report` 是否属于本次范围,明确放进 Unknowns(1、2、6、7),不在 Out of Scope 中提前判定。还在 §8 加了显式注意:“CSV、集計レポート、`api_find_report` 是否属于本次范围未确认,置于 Unknowns,不在此处提前判定”。
- “最新”口径分歧给了 候选 A(`cdr.start_date` 最大) / 候选 B(沿用 `customer_notes.max(id)`)两种选项,直接让业务侧拍板,极佳。
- 明确指出「発信」vs「発着信」歧义。
- §12 明确警告:代码调查的“最小修改候选范围”不得在本卡阶段升级为“必须修改文件”。
- 涵盖了 admin_edit / admin_view 一致性,Codex 没写。
- 风险条目颗粒度合适(共 7 条),没有膨胀到实现层面。

### 问题
- §5 现状中描述 `target=2` 在「顧客最新情報」是 `customer_notes.max(id)` 链路时,虽然属于代码调查事实而非需求决定,但条目偏多,有“现状报告化”的轻微倾向(不算实现污染,但比 Codex 略冗长)。
- 部分 AC(如 AC-006 / AC-007)需要等 Unknowns 收敛后才能执行,这一点已明示但未做更明显的占位标记。
- 未列出多语言 / 列宽 / 排序等次级 Unknown。

### 可吸收内容
- “最新”口径的“候选 A / 候选 B”二选一表述。
- AC + Regression AC 的拆分结构。
- Unknowns 编号化(1~8)便于后续逐条收敛跟踪。
- §8 末尾「CSV / 集計 / api 待定,不在此处定版」的注释句式。
- admin_edit / admin_view 同步行为的覆盖。

---

## 4. Candidate C: DeepSeek 评价

### 优点
- 信息量最丰富,操作路径用编号步骤化(§4),对手动验收路径很友好。
- 现状用表格呈现(§5),阅读效率高。
- 列出了若干其他 Candidate 没写的次级 Unknown:多语言 / 权限 / 列宽 / 排序 / 筛选。
- AC-001 ~ AC-007 + Regression-001 划分清晰。
- 风险条目颗粒度最细,涵盖性能、CSV 编码转义、API 兼容性等。

### 问题(必须指出的几条)
- **严重:把 Unknown 当成已确认事实。** §8 「明确不做 Out of Scope」第 1 条直接写「不涉及集計レポート(type=2)」「本次不要求集計レポート…」,但 §9 Unknowns 第 2 条又写「本次要求是否只要求 表形式レポート 支持?还是同时要求 集計レポート 也能…」。**同一卡内 §8 与 §9 自相矛盾,§8 已经把 §9 的 Unknown 替业务拍板了**——这是把未确认范围当成确认范围,违反本阶段“未知保留在 Unknowns”的规则。
- **严重:混入实现方案。** §7 In Scope 第 5 条直接写「字段名建议为代码方便映射的名称,如 `cdr_latest_start_date`」;§11 风险 2、§12 第 3 条直接讨论查询性能设计、lateral join / 子查询 / 窗口函数;§12 第 6 条出现 i18n 语言文件 key 实现建议——这些都属于工程卡的产物,不是 Requirement Card 应该产出的内容。
- **倾向性写法。** §6 期望结果第 4 条「现暂按需求提到的“cdr参照”理解为基于 Cdr 表的最新年月日时」、§7 第 5 条「默认期望按 `Cdr.start_date` 降序取第一条」——已经在向 `cdr.start_date` 这一未确认口径默认倾斜,而 Codex / Claude 都把这一点保留在 Unknowns 中作为业务侧拍板项。
- **CSV 范围不一致。** §6 期望结果第 3 条 / §7 In Scope 第 4 条已经把「表形式 CSV 下载」纳入范围并写进 AC-004,但 §9 Unknowns 第 5 条又问「CSV 下载属于验收范围吗?」——CSV 同时出现在 In Scope + AC + Unknowns,自相矛盾。
- §7 第 2 条把「順番:追加在现有系统字段及可能的自定义字段之后(最后一位)」直接写成 In Scope 已确认,而 §9 Unknowns 第 4 条又问「最后一位」是仅系统字段后还是含自定义字段后——同一项被同时定版与待确认。
- §5 「无数据展示」描述「尚无统一约定」但未明确升级为 Unknown 的形式化条目(已在 §9 第 3 条提到,但 §5 仍以现状描述呈现)。

### 可吸收内容
- 次级 Unknown 项:多语言文案、列宽 / 排序 / 筛选默认行为、权限可见性——可作为补充 Unknown 加入主卡。
- §5 现状表格化的呈现形式可读性较好。
- 操作路径步骤化(§4)的写法可用于 AC 手动执行指引。

---

## 5. 横向对比表

| 维度 | Codex (A) | Claude (B) | DeepSeek (C) |
|---|---|---|---|
| 1. 保留领导原话 | ✅ 完整 | ✅ 完整 | ✅ 完整 |
| 2. 准确识别主目标 | ✅ | ✅ | ✅ |
| 3. 区分 已确认/推测/未知 | ✅ 最严格,每条都标注 | ✅ 严格 | ⚠️ 部分 Unknown 写成已确认事实(集計 / 順番 / CSV) |
| 4. 表形式 vs 集計 范围差异 | ✅ 放进 Unknowns | ✅ 放进 Unknowns 并加注 | ❌ §8 直接拍板「集計不做」,与自己 §9 Unknown 矛盾 |
| 5. 「最新」口径风险 | ✅ 显式保留(`customer_notes.id` vs `cdr.start_date`) | ✅ 给出候选 A/B 让业务拍板 | ⚠️ 默认倾向 `cdr.start_date`,未严格保留为 Unknown |
| 6. 是否进入实现方案 | ✅ 完全未进入 | ✅ 未进入 | ❌ 混入字段命名建议、SQL 策略、性能设计、i18n 实现 |
| 7. AC 可手动验证 | ✅ 但 AC 偏粗 | ✅ AC + Regression 分组,可直接执行 | ✅ AC 详细 |
| 8. Unknowns 完整性 | ✅ 9 条,覆盖核心 | ✅ 8 条,编号化便于追踪 | ⚠️ 9 条但与 In Scope / Out of Scope 冲突 |
| 9. 风险与歧义 | ✅ 含「発信 vs 発着信」、「id DESC vs start_date DESC」 | ✅ 含同上,且 7 条颗粒度合适 | ⚠️ 含性能 / CSV 编码 / API 兼容,部分是实现层风险 |
| 10. 是否适合作为后续 frozen 基础 | ✅ 最克制,基础最干净 | ✅ 推荐主卡,结构完整 | ❌ 需要先剥离实现污染与自相矛盾项 |

---

## 6. 关键风险保留情况

- **Unknown 写成已确认事实:** DeepSeek 在 §8 把「集計レポート不做」拍板,但 §9 第 2 条又问「是否要求集計レポート」;在 §7 把「表形式 CSV」纳入 In Scope 并写进 AC-004,但 §9 第 5 条又问「CSV 是否属于验收范围」;在 §7 把「最后一位」拍板,但 §9 第 4 条又问「最后一位」边界——这些都是“Unknown 被当成已确认”。Codex 与 Claude 没有该问题。
- **「最新 = Cdr.start_date 最大值」直接当成确定事实:** DeepSeek §6 第 4 条「现暂按需求提到的“cdr参照”理解为基于 Cdr 表的最新年月日时」、§7 第 5 条「默认期望按 `Cdr.start_date` 降序取第一条」——已经在向该口径倾斜。Codex 与 Claude 都明确将该口径保留为 Unknown(Claude 还给出了 候选 A / B 二选一的形式)。
- **忽略集計レポート范围风险:** Codex 与 Claude 都没忽略,显式列为 Unknown。DeepSeek 在 §8 反向问题——不是忽略,而是错误地拍板为「不做」。
- **忽略 CSV / API / 表形式 CSV / 集計 CSV 范围未知:** Codex 与 Claude 都显式保留为 Unknown。DeepSeek 部分保留(API 在 Unknown 第 6),但 CSV 自相矛盾(同时在 In Scope、AC 和 Unknown 出现)。
- **混入实现方案:** DeepSeek 违反此点(字段命名 `cdr_latest_start_date`、SQL 实现策略、性能设计、i18n 语言文件 key)。Codex 与 Claude 均未混入。

---

## 7. 推荐主卡

**推荐主卡:Candidate B (Claude)**

理由:

1. 结构最完整(已确认 / 推测 / 未知 / 风险 / AC / Regression AC / Unknowns 编号 / 给工程卡的输入提醒,全部齐全)。
2. 「最新」口径用 候选 A / 候选 B 二选一形式,业务侧只需勾一项即可收敛——是三张中收敛效率最高的写法。
3. CSV / 集計 / API 严格放进 Unknowns,且 §8 末尾显式注释「不在此处提前判定」,杜绝 DeepSeek 出现的“Unknown 被拍板”问题。
4. 完全没有进入实现方案,符合 M1 阶段的产出边界。
5. 显式覆盖 admin_edit / admin_view 一致性,verification 面比 Codex 完整。
6. 风险条目颗粒度适中,既不缺失也不膨胀到实现层。

备选主卡:Candidate A (Codex),若希望卡更克制、Unknowns 更彻底,可改用 Codex 为主卡。但 Codex 的 AC 颗粒度比 Claude 略粗,且未覆盖 admin_edit / admin_view 一致性。

不推荐主卡:Candidate C (DeepSeek),因 §8 与 §9 自相矛盾(集計 / CSV / 順番),并混入实现方案,需要先剥离再使用。

---

## 8. 合并建议

以 Claude (B) 为主卡基础,合并时:

1. **吸收 Codex (A):**
   - §12 中「代码调查只能作为需求澄清依据,不能直接跳成实现指令」的措辞作为新主卡 §12 的总括句。
   - 「発信 vs 発着信 / 日付 vs 日時」的歧义在新主卡 §11 中作为单独歧义条保留(Claude 已有,可强化)。
   - Codex §5 中「`/admin/cdr/index` 默认排序更接近 `id DESC`,不能直接等同 `start_date DESC`」的隐性偏差措辞,可补强到 Claude §11 风险 6 的描述。

2. **吸收 DeepSeek (C) 仅次级条目,且全部转为 Unknown 形式:**
   - 多语言文案 / 翻译范围(转为新 Unknown,而非 In Scope)。
   - 列宽、可排序、可筛选的默认行为(转为新 Unknown)。
   - 权限可见性是否需要限制(转为新 Unknown)。
   - 操作路径步骤化(§4)的写法可用于 AC 手动执行指引的描述方式。
   - **明确剔除**:DeepSeek 的字段命名建议、SQL / 性能设计、i18n 实现建议——全部不并入主卡,作为工程卡阶段的待澄清项。
   - **明确剔除**:DeepSeek §8 中「不涉及集計レポート」「不修改 API 数据结构」这两项拍板,改回 Unknown 待业务确认。

3. **新主卡产出前必须收敛的最小 Unknowns 集合(建议作为 §9 顶部块):**
   - 「最新」口径:`cdr.start_date` 最大值 vs `customer_notes.max(id)` 关联 cdr。
   - 范围:仅 表形式 / type=1 / target=2,还是同时含 集計 / type=2 / target=2。
   - CSV 范围:表形式 CSV / 集計 CSV 是否纳入验收。
   - API 范围:`api_find_report` 是否同步影响。
   - 「順番最后一位」边界:仅系统字段最后 vs 含自定义字段后全列表最后。
   - 无 発着信履歴 数据时的显示规则。
   - 「発信」vs「発着信」、「日付」vs「日時」的表述差异如何对应到 cdr 数据筛选条件。

4. **主卡输出后强烈建议:**
   不要在 M1 阶段把任何 Unknown 移到 In Scope 或 Out of Scope,所有范围拍板必须由业务侧回答 Unknowns 后,统一由下一轮 frozen 主卡承载。
