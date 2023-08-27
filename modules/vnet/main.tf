
resource "azurerm_virtual_network" "vnet" {
    name                        = var.virtual_network_name
    resource_group_name         = var.resource_group_name
    location                    = var.location
    address_space               = var.virtual_network_address_space
}

resource "azurerm_subnet" "subnet" {
  for_each              = var.subnet_names
  name                  = each.value.subnet_name
  virtual_network_name  = azurerm_virtual_network.vnet.name
  resource_group_name   = var.resource_group_name
  address_prefixes      = each.value.address_prefixes
dynamic "delegation" {
     for_each = { for delegate in var.delegations : delegate.name => delegate 
                  if each.value.snet_delegation == "appservice" }
    content {
      name = "delegation-appService"
      service_delegation {
      name    = "Microsoft.Web/serverFarms"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/action",
        ]
      }
    }
}
dynamic "delegation" {
     for_each = { for delegate in var.delegations : delegate.name => delegate 
                  if each.value.snet_delegation == "mysql" }
    content {
      name = "delegation-database"
      service_delegation {
      name    = "Microsoft.DBforMySQL/flexibleServers"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/join/action",
        ]
      }
    }
}
dynamic "delegation" {
  for_each = { for delegate in var.delegations : delegate.name => delegate 
                  if each.value.snet_delegation == "aks" }
    content {
    name = "aciDelegation"
    service_delegation {
      name    = "Microsoft.ContainerInstance/containerGroups"
      actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
    }
  }
}
}