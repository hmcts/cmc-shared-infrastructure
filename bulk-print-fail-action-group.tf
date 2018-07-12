module "cmc-bulk-print-fail-action-group" {
  source = "git@github.com:hmcts/cnp-module-action-group"
  location = "global"
  env = "${var.env}"

  resourcegroup_name = "${azurerm_resource_group.rg.name}"
  action_group_name = "Bulk Print Fail Alert - ${var.env}"
  short_name = "BPF_alert"
  email_receiver_name = "Bulk Print Alerts"
//  email_receiver_address = "cmc-bulk-print-alerts@hmcts.net" - disable for testing
  email_receiver_address = "andrew.walker@hmcts.net"
}
