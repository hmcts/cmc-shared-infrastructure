data "azurerm_key_vault" "cmc_key_vault" {
  name = "cmc-${var.env}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
}

data "azurerm_key_vault_secret" "pdf_fail_email_secret" {
  name = "pdf-failure-email"
  vault_uri = "${data.azurerm_key_vault.cmc_key_vault.vault_uri}"
}

module "cmc-pdf-fail-action-group" {
  source = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env = "${var.env}"

  resourcegroup_name = "${azurerm_resource_group.rg.name}"
  action_group_name = "PDF Failure Alert - ${var.env}"
  short_name = "PDF_alert"
  email_receiver_name = "PDF Failure Alerts"
  email_receiver_address = "${data.azurerm_key_vault_secret.pdf_fail_email_secret.value}"
}

output "pdf_action_group_name" {
  value = "${module.cmc-pdf-fail-action-group.action_group_name}"
}
