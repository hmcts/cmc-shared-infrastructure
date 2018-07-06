module "cmc-bulk-print-fail-action-group" {
  source = "git@github.com:hmcts/moj-module-action-group"
  location = "${var.location}"
  env = "${var.env}"
  resourcegroup_name = "${azurerm_resource_group.rg.name}"
  group_name = "BPF_${var.env}"
  alert_name = "Bulk Print Fail Alert - ${var.env}"
  alert_short_name = "BPF_alert"
  email_receiver_name = "Bulk Print Alerts"
  email_receiver_address = "cmc-bulk-print-alerts@hmcts.net"
}
