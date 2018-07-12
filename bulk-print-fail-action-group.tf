module "cmc-bulk-print-fail-action-group" {
  source = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env = "${var.env}"

  resourcegroup_name = "${azurerm_resource_group.rg.name}"
  action_group_name = "Bulk Print Fail Alert - ${var.env}"
  short_name = "BPF_alert"
  email_receiver_name = "Bulk Print Alerts"
//  email_receiver_address = "cmc-bulk-print-alerts@hmcts.net" - disable for testing module inheritance
  email_receiver_address = "andrew.walker@hmcts.net"
}

resource "azurerm_template_deployment" "action_group" {
  deployment_mode = "Incremental"
  name = "${module.cmc-bulk-print-fail-action-group.action_group_name}"
  resource_group_name = "${module.cmc-bulk-print-fail-action-group.resourcegroup_name}"
}