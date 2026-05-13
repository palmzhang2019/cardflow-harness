# Model Input

- task_id: 24174-customer-latest-info-add-send-date
- stage: m1-requirement-card
- round: round-1
- model: claude

---

## Instruction

# M1 Requirement Card Candidate Generator

你现在是 Requirement Card Candidate 生成 Agent。

你的任务：
基于输入材料 `00-material-package.md`，生成一张 Requirement Card Candidate。

当前阶段：
只允许生成 M1 Requirement Card Candidate。

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

必须遵守：
- 保留领导原话，不美化、不改写
- 区分：已确认 / 推测 / 未知
- 代码调查报告只能作为需求澄清依据
- Unknowns 必须保留
- 风险必须明确写出
- Acceptance Criteria 必须可手动验证
- 输出 Markdown
- 标题必须是：# Requirement Card Candidate

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

重点 Unknowns，不能脑补：
- 这次是否只要求「表形式レポート」支持「発着信日時（最新）」
- 「集計レポート」是否也必须支持「発着信日時（最新）」
- 「発着信日時（最新）」的“最新”口径到底是 Cdr.start_date 最大值，还是现有 顧客最新情報 的 customer_notes.id 最大值逻辑
- 无 発着信履歴 数据时应该显示什么
- 順番 的“最后一位”是指系统字段最后，还是包含自定义字段后的全列表最后
- CSV 是否属于本次验收范围
- api_find_report 是否需要同步影响
- 表形式 CSV / 集計 CSV 是否属于本次范围

输出要求：
只输出 Requirement Card Candidate 本文。
不要解释你将如何做。
不要输出多余寒暄。

---

## Material Package

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