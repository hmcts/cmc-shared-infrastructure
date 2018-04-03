locals {
  default_resource_group_name = "${var.product}-${var.env}"
  resource_group_name         = "${var.resource_group_name != "" ? var.resource_group_name : local.default_resource_group_name}"
}

# Create a resource group
resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_group_name}"
  location = "${var.location}"
}


# Create Application Insights for the service
resource "azurerm_application_insights" "appinsights" {
  name                = "${var.product}-appinsights-${var.env}"
  location            = "${var.appinsights_location}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  application_type    = "${var.application_type}"
}

locals {
  app_settings_evaluated = {
    APPLICATION_INSIGHTS_IKEY = "${azurerm_application_insights.appinsights.instrumentation_key}"

    # Support for nodejs apps (java apps to migrate to this env var in future PR)
    APPINSIGHTS_INSTRUMENTATIONKEY = "${azurerm_application_insights.appinsights.instrumentation_key}"
  }
}
