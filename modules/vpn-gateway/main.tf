# Azure Virtual Network Gateway
resource azurerm_virtual_network_gateway "virtual_network_gateway" {
    name                = var.vpn_gateway_name
    location            = var.location
    resource_group_name = var.resource_group_name

    type     = var.type
    vpn_type = var.vpn_type

    sku           = var.sku
    active_active = var.active_active
    enable_bgp    = var.enable_bgp

    ip_configuration {
        name                          = var.ip_configuration
        private_ip_address_allocation = var.private_ip_address_allocation
        subnet_id                     = var.subnet_id
        public_ip_address_id          = var.public_ip_address_id
    }
}