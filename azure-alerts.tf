module "cmc-bulk-print-fail-alert" {
  source = "git@github.com:hmcts/cnp-module-metric-alert"
  location = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  alert_name = "Bulk print failure - CMC"
  alert_desc = "Triggers when a bulk print failure event is received from CMC in a 5 minute poll."
  app_insights_query = "customEvents | where name == \"Bulk print failed\""
  frequency_in_minutes = 5
  time_window_in_minutes = 5
  severity_level = "3"
  action_group_name = "${module.cmc-bulk-print-fail-action-group.action_group_name}"
  custom_email_subject = "CMC Bulk Print Failure"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold = 0
  resourcegroup_name = "${azurerm_resource_group.rg.name}"
}

module "cmc-pdf-fail-alert" {
  source = "git@github.com:hmcts/cnp-module-metric-alert"
  location = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  alert_name = "PDF failure - CMC"
  alert_desc = "Triggers when a PDF failure event is received from CMC in a 5 minute poll."
  app_insights_query = <<AIQ
requests
| join (exceptions | where customDimensions != "") on operation_Id
| join (dependencies | where target == "cmc-pdf-service-prod.service.core-compute-prod.internal") on operation_Id
| where name startswith "POST"
AIQ
  frequency_in_minutes = 5
  time_window_in_minutes = 5
  severity_level = "3"
  action_group_name = "${module.cmc-pdf-fail-action-group.action_group_name}"
  custom_email_subject = "CMC PDF Failure"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold = 0
  resourcegroup_name = "${azurerm_resource_group.rg.name}"
}
