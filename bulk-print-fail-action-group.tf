
data "azurerm_key_vault" "cmc_key_vault" {
  name = "cmc-${var.env}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

data "azurerm_key_vault_secret" "bpf_email_secret" {
  name = "bulk-print-failure-email"
  vault_uri = "${data.azurerm_key_vault.cmc_key_vault.vault_uri}"
}

module "cmc-bulk-print-fail-action-group" {
  source = "git@github.com:hmcts/cnp-module-action-group?ref=feature/ROC-3821"
  location = "${(var.env == "prod") ? var.location : "global"}"
  env = "${var.env}"

  resourcegroup_name = "${azurerm_resource_group.rg.name}"
  action_group_name = "Bulk Print Fail Alert - ${var.env}"
  short_name = "BPF_alert"
  email_receiver_name = "Bulk Print Alerts"
  email_receiver_address = "${data.azurerm_key_vault_secret.bpf_email_secret.value}"
}

output "action_group_name" {
  value = "${module.cmc-bulk-print-fail-action-group.action_group_name}"
}