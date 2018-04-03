module "cmc-vault" {
  source = "git@github.com:contino/moj-module-key-vault?ref=master"
  name = "cmc-${var.env}"
  product = "${var.product}"
  env = "${var.env}"
  tenant_id = "${var.tenant_id}"
  object_id = "${var.jenkins_AAD_objectId}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  product_group_object_id = "68839600-92da-4862-bb24-1259814d1384"
}

output "vaultName" {
  value = "${module.cmc-vault.name}"
}
