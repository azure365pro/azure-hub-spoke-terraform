variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "location" {
  type = string
}

/*
App Service Settings
*/

variable "service_plan_id" {
  description = "App service SKU"
  default     = "P1v2"
}

variable "app_service_alwayson" {
  description = "App service Always On"
  default     = true
}

variable "subnet_id" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "web_app_name" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "php_version" {
  description = "The full Azure resource ID of the remote virtual network."
}


