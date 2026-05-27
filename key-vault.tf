data "azurerm_user_assigned_identity" "jenkins" {
  name                = "jenkins-${var.env}-mi"
  resource_group_name = "managed-identities-${var.env}-rg"
}

module "cmc-vault" {
  source                       = "git@github.com:hmcts/cnp-module-key-vault?ref=DTSPO-31965/remove-jenkins-ptl-access-da"
  name                         = "cmc-${var.env}"
  product                      = var.product
  env                          = var.env
  tenant_id                    = var.tenant_id
  object_id                    = var.jenkins_AAD_objectId
  jenkins_object_id            = data.azurerm_user_assigned_identity.jenkins.principal_id
  resource_group_name          = azurerm_resource_group.rg.name
  product_group_object_id      = "68839600-92da-4862-bb24-1259814d1384"
  common_tags                  = local.tags
  create_managed_identity      = true
  grant_preview_jenkins_access = var.env == "aat"
}

data "azurerm_key_vault" "cmc_key_vault" {
  name                = "cmc-${var.env}"
  resource_group_name = azurerm_resource_group.rg.name
}

output "vaultName" {
  value = module.cmc-vault.key_vault_name
}
