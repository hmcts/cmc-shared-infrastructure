module "cmc-vault" {
  source                  = "git@github.com:hmcts/cnp-module-key-vault?ref=master"
  name                    = "cmc-${var.env}"
  product                 = var.product
  env                     = var.env
  tenant_id               = var.tenant_id
  object_id               = var.jenkins_AAD_objectId
  resource_group_name     = azurerm_resource_group.rg.name
  product_group_object_id = "68839600-92da-4862-bb24-1259814d1384"
  common_tags             = local.tags
  create_managed_identity = true
}

data "azurerm_key_vault" "cmc_key_vault" {
  name                = "cmc-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
}

output "vaultName" {
  value = module.cmc-vault.key_vault_name
}
