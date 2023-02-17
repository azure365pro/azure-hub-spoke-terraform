
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
}
