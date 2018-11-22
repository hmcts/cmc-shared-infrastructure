module "shutterPage" {
  source = "git@github.com:hmcts/moj-module-shutterpage?ref=CNP-585"
  location = "${var.location}"
  env = "${var.env}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  tag_list = "${local.tags}"
  product = "${var.product}"
  customDomain = "$(var.citizen_shutter_domain)"
  subscription = "${var.subscription}"
}