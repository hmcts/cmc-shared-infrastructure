variable "product" {}

variable "location" {
  default = "UK South"
}

// as of now, UK South is unavailable for Application Insights
variable "appinsights_location" {
  default     = "West Europe"
  description = "Location for Application Insights"
}

variable "common_tags" {
  type = map(any)
}

variable "env" {}

variable "application_type" {
  default     = "web"
  description = "Type of Application Insights (Web/Other)"
}

variable "tenant_id" {
  description = "(Required) The Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. This is usually sourced from environemnt variables and not normally required to be specified."
}

variable "jenkins_AAD_objectId" {
  description = "(Required) The Azure AD object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies."
}

variable "subscription" {}

variable "team_contact" {
  default = "#cmc-tech"
}

variable "name" {
  default = false
}

variable "asp_capacity" {
  default = 2
}

variable "citizen_external_hostname" {}
variable "citizen_external_cert_name" {}
variable "citizen_external_cert_vault_uri" {}
variable "legal_external_hostname" {}
variable "legal_external_cert_name" {}
variable "legal_external_cert_vault_uri" {}

variable "ilbIp" {
  default = ""
}
variable "sku" {
  default     = "standard"
  description = "The Name of the SKU used for this Key Vault. Possible values are standard and premium."
}
