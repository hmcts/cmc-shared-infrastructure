module "cmc-bulk-print-failures" {
  source = "git@github.com:andrewwa-kainos/moj-module-action-group"
  location = "${var.location}"
  env = "${var.env}"
  subscription = "DCD-CFT-Sandbox"
  resourcegroup_name = "${azurerm_resource_group.rg.name}"
  group_name = "BPF_${var.env}"
  alert_name = "Bulk Print Fail Alert - ${var.env}"
  alert_short_name = "bpfprinterr"
  email_receiver_name = "Andy"
  email_receiver_address = "andrew.walker@hmcts.net"
}
