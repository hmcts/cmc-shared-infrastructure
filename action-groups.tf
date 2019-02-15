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

// Test print failures
module "cmc-test-fail-action-group" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = "${var.env}"

  resourcegroup_name     = "${azurerm_resource_group.rg.name}"
  action_group_name      = "Test Fail Alert - ${var.env}"
  short_name             = "Test_alert"
  email_receiver_name    = "Test Print Alerts"
  email_receiver_address = "${data.azurerm_key_vault_secret.bpf_email_secret.value}"
}

output "test_action_group_name" {
  value = "${module.cmc-test-fail-action-group.action_group_name}"
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

output "ff4j_failure_action_group" {
  value = "${data.azurerm_key_vault_secret.ff4j_email_secret.value}"
}

// CMC Document Management Failure

data "azurerm_key_vault_secret" "document_management_email_secret" {
  name      = "document-management-failure-email"
  vault_uri = "${data.azurerm_key_vault.cmc_key_vault.vault_uri}"
}

module "cmc-document-management-failure-action-group" {
  source   = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env      = "${var.env}"

  resourcegroup_name     = "${azurerm_resource_group.rg.name}"
  action_group_name      = "Document Management Failure Alert - ${var.env}"
  short_name             = "DMF_alert"
  email_receiver_name    = "Document Management Failure Alerts"
  email_receiver_address = "${data.azurerm_key_vault_secret.document_management_email_secret.value}"
}

