variable "product" {
  type = "string"
}

variable "location" {
  type    = "string"
  default = "UK South"
}

// as of now, UK South is unavailable for Application Insights
variable "appinsights_location" {
  type        = "string"
  default     = "West Europe"
  description = "Location for Application Insights"
}

variable "env" {
  type = "string"
}

variable "resource_group_name" {
  type        = "string"
  default     = ""
  description = "Resource group name for the web application. If empty, the default will be set"
}

variable "application_type" {
  type        = "string"
  default     = "Web"
  description = "Type of Application Insights (Web/Other)"
}
