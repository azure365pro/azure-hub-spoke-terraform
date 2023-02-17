data "azurerm_client_config" "current" {}

resource "azurerm_user_assigned_identity" "base" {
  location            = var.location
  resource_group_name = var.resource_group_name 
  name                = var.managed_identity_name
}

resource "azurerm_key_vault" "kv" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name 
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = var.sku_name
  access_policy {
    object_id                = data.azurerm_client_config.current.object_id
    tenant_id                = data.azurerm_client_config.current.tenant_id

    certificate_permissions  =  var.admin_certificate_permissions  
    key_permissions          = var.admin_key_permissions 
    secret_permissions       = var.admin_secret_permissions 

  }

  access_policy {
    object_id    = azurerm_user_assigned_identity.base.principal_id
    tenant_id    = data.azurerm_client_config.current.tenant_id

    secret_permissions = var.managed_identity_secret_permissions
  }
}