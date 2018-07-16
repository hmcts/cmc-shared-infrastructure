data "vault_generic_secret" "bpf_address" {
  path = "secrets/bpf-alert-email"
}

module "cmc-bulk-print-fail-action-group" {
  source = "git@github.com:hmcts/cnp-module-action-group"
  location = "${var.location}"
  env = "${var.env}"

  resourcegroup_name = "${azurerm_resource_group.rg.name}"
  action_group_name = "Bulk Print Fail Alert - ${var.env}"
  short_name = "BPF_alert"
  email_receiver_name = "Bulk Print Alerts"
  email_receiver_address = "${data.vault_generic_secret.bpf_address.data}"
}
