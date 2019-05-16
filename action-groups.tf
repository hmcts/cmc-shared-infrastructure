// Bulk print failures

data "azurerm_key_vault_secret" "bpf_email_secret" {
  name      = "bulk-print-failure-email"
  vault_uri = "${data.azurerm_key_vault.cmc_key_vault.vault_uri}"
}

module "cmc-bulk-print-fail-action-group" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = "${var.env}"

  resourcegroup_name     = "${azurerm_resource_group.rg.name}"
  action_group_name      = "Bulk Print Fail Alert - ${var.env}"
  short_name             = "BPF_alert"
  email_receiver_name    = "Bulk Print Alerts"
  email_receiver_address = "${data.azurerm_key_vault_secret.bpf_email_secret.value}"
}

output "bpf_action_group_name" {
  value = "${module.cmc-bulk-print-fail-action-group.action_group_name}"
}

// PDF service failures

data "azurerm_key_vault_secret" "pdf_fail_email_secret" {
  name      = "pdf-failure-email"
  vault_uri = "${data.azurerm_key_vault.cmc_key_vault.vault_uri}"
}

module "cmc-pdf-fail-action-group" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = "${var.env}"

  resourcegroup_name     = "${azurerm_resource_group.rg.name}"
  action_group_name      = "PDF Failure Alert - ${var.env}"
  short_name             = "PDF_alert"
  email_receiver_name    = "PDF Failure Alerts"
  email_receiver_address = "${data.azurerm_key_vault_secret.pdf_fail_email_secret.value}"
}

output "pdf_action_group_name" {
  value = "${module.cmc-pdf-fail-action-group.action_group_name}"
}

// CMC Admission Failures

data "azurerm_key_vault_secret" "ff4j_email_secret" {
  name      = "ff4j-admissions-failure-email"
  vault_uri = "${data.azurerm_key_vault.cmc_key_vault.vault_uri}"
}

module "cmc-ff4j-admissions-fail-action-group" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = "${var.env}"

  resourcegroup_name     = "${azurerm_resource_group.rg.name}"
  action_group_name      = "ff4j Admissions Failure Alert - ${var.env}"
  short_name             = "ff4j_alert"
  email_receiver_name    = "ff4j Admissions Failure Alerts"
  email_receiver_address = "${data.azurerm_key_vault_secret.ff4j_email_secret.value}"
}

output "ff4j_failure_action_group_name" {
  value = "${module.cmc-ff4j-admissions-fail-action-group.action_group_name}"
}

// CMC Document Management Failure

data "azurerm_key_vault_secret" "doc_mgt_email_secret" {
  name      = "document-management-failure-email"
  vault_uri = "${data.azurerm_key_vault.cmc_key_vault.vault_uri}"
}

module "cmc-doc-mgt-failure-action-group" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = "${var.env}"

  resourcegroup_name     = "${azurerm_resource_group.rg.name}"
  action_group_name      = "Document Management Failure Alert - ${var.env}"
  short_name             = "DM_alert"
  email_receiver_name    = "Document Management Failure Alerts"
  email_receiver_address = "${data.azurerm_key_vault_secret.doc_mgt_email_secret.value}"
}

output "doc_mgmt_failure_action_group_name" {
  value = "${module.cmc-doc-mgt-failure-action-group.action_group_name}"
}

// Notification Failure

data "azurerm_key_vault_secret" "claim_issue_email_secret" {
  name      = "claim-issue-failure-email"
  vault_uri = "${data.azurerm_key_vault.cmc_key_vault.vault_uri}"
}

module "claim-issue-failure-action-group" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = "${var.env}"

  resourcegroup_name     = "${azurerm_resource_group.rg.name}"
  action_group_name      = "Claim Issue Failure Alert - ${var.env}"
  short_name             = "clmisu_alert"
  email_receiver_name    = "Claim Issue Failure Alerts"
  email_receiver_address = "${data.azurerm_key_vault_secret.claim_issue_email_secret.value}"
}

output "claim_issue_failure_action_group_name" {
  value = "${module.claim-issue-failure-action-group.action_group_name}"
}