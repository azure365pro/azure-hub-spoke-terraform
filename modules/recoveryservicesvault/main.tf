resource "azurerm_recovery_services_vault" "vault" {
  name                = var.recovery_vault_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = var.sku
  soft_delete_enabled = var.soft_delete_enabled
}