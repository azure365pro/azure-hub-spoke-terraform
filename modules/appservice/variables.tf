variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "location" {
  type = string
}

/*
App Service Plan Settings
*/

variable "os_type" {
  type = string
}


variable "app_service_hosting_plan_name" {
  description = "App service plan name"
  default     = "wp-appsvc-plan"
}

variable "app_service_hosting_plan_sku" {
  description = "App service SKU"
  default     = "P1v2"
}

variable "app_service_workers" {
  description = "App service Workers"
  default     = 1
}
