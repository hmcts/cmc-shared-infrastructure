resource "azurerm_resource_group" "rg" {
  // TODO change this back to product-env
  name     = "${var.product}-${var.env}-shared-infrastructure"
  location = "${var.location}"
}
