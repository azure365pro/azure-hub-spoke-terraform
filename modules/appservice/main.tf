resource "azurerm_service_plan" "app_service_hosting_plan" {
  location            = var.location
  name                = var.app_service_hosting_plan_name
  os_type             = var.os_type
  resource_group_name = var.resource_group_name
  sku_name            = var.app_service_hosting_plan_sku
  worker_count        = var.app_service_workers
}

