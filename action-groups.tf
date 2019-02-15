// Bulk print failures
module "cmc-bulk-print-fail-action-group" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = "${var.env}"

  resourcegroup_name     = "${azurerm_resource_group.rg.name}"
  action_group_name      = "Bulk Print Fail Alert - ${var.env}"
  short_name             = "BPF_alert"
  email_receiver_name    = "Bulk Print Alerts"
  email_receiver_address = "bulk-print-failure@email.com"
}

output "bpf_action_group_name" {
  value = "${module.cmc-bulk-print-fail-action-group.action_group_name}"
}

// PDF service failures
module "cmc-pdf-fail-action-group" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = "${var.env}"

  resourcegroup_name     = "${azurerm_resource_group.rg.name}"
  action_group_name      = "PDF Failure Alert - ${var.env}"
  short_name             = "PDF_alert"
  email_receiver_name    = "PDF Failure Alerts"
  email_receiver_address = "pdf-failure@email.com"
}

output "pdf_action_group_name" {
  value = "${module.cmc-pdf-fail-action-group.action_group_name}"
}

// CMC Admission Failures
module "cmc-ff4j-admissions-fail-action-group" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = "${var.env}"

  resourcegroup_name     = "${azurerm_resource_group.rg.name}"
  action_group_name      = "ff4j Admissions Failure Alert - ${var.env}"
  short_name             = "ff4j_alert"
  email_receiver_name    = "ff4j Admissions Failure Alerts"
  email_receiver_address = "ff4j-admissions-failure@email.com"
}

output "ff4j_failure_action_group_name" {
  value = "${module.cmc-ff4j-admissions-fail-action-group.action_group_name}"
}

// CMC Document Management Failure
module "cmc-doc-mgt-failure-action-group" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = "${var.env}"

  resourcegroup_name     = "${azurerm_resource_group.rg.name}"
  action_group_name      = "Document Management Failure Alert - ${var.env}"
  short_name             = "DM_alert"
  email_receiver_name    = "Document Management Failure Alerts"
  email_receiver_address = "doc-mgt-failure@email.com"
}
output "doc_mgmt_failure_action_group_name" {
  value = "${module.cmc-doc-mgt-failure-action-group.action_group_name}"
}
