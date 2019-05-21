module "cmc-doc-mgt-fail-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  alert_name = "cmc-doc-mgt-fail-alert"
  alert_desc = "Triggers when a Document Management upload or download failure event is received from CMC in a 5 minute poll."

  app_insights_query = <<AIQ
customEvents
| where name == "Document management upload - failure" or name == "Document management download - failure"
AIQ

  frequency_in_minutes       = 5
  time_window_in_minutes     = 5
  severity_level             = "3"
  action_group_name          = "${module.cmc-doc-mgt-failure-action-group.action_group_name}"
  custom_email_subject       = "CMC Document Management Failure"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}

module "cmc-bulk-print-fail-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  alert_name                 = "cmc-bulk-print-fail-alert"
  alert_desc                 = "Triggers when a bulk print failure event is received from CMC in a 5 minute poll."
  app_insights_query         = "customEvents | where name == \"Bulk print failed\""
  frequency_in_minutes       = 5
  time_window_in_minutes     = 5
  severity_level             = "3"
  action_group_name          = "${module.cmc-bulk-print-fail-action-group.action_group_name}"
  custom_email_subject       = "CMC Bulk Print Failure"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}

module "cmc-pdf-fail-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  alert_name = "cmc-pdf-fail-alert"
  alert_desc = "Triggers when a PDF failure event is received from CMC in a 30 minute poll."

  app_insights_query = <<AIQ
requests
| where name startswith "POST"
| join (exceptions
| search "cmc-pdf-service"
| where customDimensions != ""
| project operation_Id, dimensions=customDimensions) on operation_Id
| project timestamp, operation_Id, url, name, dimensions
AIQ

  frequency_in_minutes       = 30
  time_window_in_minutes     = 30
  severity_level             = "3"
  action_group_name          = "${module.cmc-pdf-fail-action-group.action_group_name}"
  custom_email_subject       = "CMC PDF Failure"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}

module "cmc-ff4j-admissions-fail-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  alert_name                 = "cmc-ff4j-admissions-fail-alert"
  alert_desc                 = "Triggers when a ff4J cmc_admissions failure event is received from CMC in a 5 minute poll."
  app_insights_query         = "customEvents | where name == \"ff4J cmc_admissions failure\""
  frequency_in_minutes       = 5
  time_window_in_minutes     = 5
  severity_level             = "3"
  action_group_name          = "${module.cmc-ff4j-admissions-fail-action-group.action_group_name}"
  custom_email_subject       = "CMC FF4J CMC_Admissions Failure"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}

module "claim-issue-fail-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  alert_name                 = "claim-issue-fail-alert"
  alert_desc                 = "Triggers when a Claim issue failure event is received from CMC in a 5 minute poll."
  app_insights_query         = "customEvents | where name == \"Notification - failure\""
  frequency_in_minutes       = 5
  time_window_in_minutes     = 5
  severity_level             = "3"
  action_group_name          = "${module.claim-issue-failure-action-group.action_group_name}"
  custom_email_subject       = "Claim Issue Notification Failure"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}

module "milo-report-fail-alert" {
  source            = "git@github.com:hmcts/cnp-module-metric-alert"
  location          = "${azurerm_application_insights.appinsights.location}"
  app_insights_name = "${azurerm_application_insights.appinsights.name}"

  alert_name                 = "milo-report-fail-alert"
  alert_desc                 = "Triggers when a Mediation report failure event is received from CMC in a 1 hour poll."
  app_insights_query         = "customEvents | where name == \"Mediation Report - failure\""
  frequency_in_minutes       = 60
  time_window_in_minutes     = 60
  severity_level             = "3"
  action_group_name          = "${module.milo-report-failure-action-group.action_group_name}"
  custom_email_subject       = "MILO Report Failure"
  trigger_threshold_operator = "GreaterThan"
  trigger_threshold          = 0
  resourcegroup_name         = "${azurerm_resource_group.rg.name}"
}
