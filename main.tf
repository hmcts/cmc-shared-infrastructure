locals {
  default_resource_group_name = "${var.product}-${var.env}"
  resource_group_name         = "${var.resource_group_name != "" ? var.resource_group_name : local.default_resource_group_name}"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_group_name}"
  location = "${var.location}"
}
