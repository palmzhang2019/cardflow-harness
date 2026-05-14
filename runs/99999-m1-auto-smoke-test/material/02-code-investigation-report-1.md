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