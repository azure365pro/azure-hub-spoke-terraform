#Private Endpoints

resource "azurerm_private_endpoint" "pe" {
  name                = var.pvt_endpoint_name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id

  private_service_connection {
    name                           = var.private_service_connection_name
    is_manual_connection           = var.is_manual_connection
    private_connection_resource_id = var.private_connection_resource_id
    subresource_names               = [var.subresource_name]
  }
}