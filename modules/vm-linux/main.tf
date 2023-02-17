resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.ipconfig_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address
  }
}
resource "azurerm_linux_virtual_machine" "linux-vm" {
  name                            = var.virtual_machine_name
  location                        = var.location
  resource_group_name             = var.resource_group_name
  network_interface_ids           = [azurerm_network_interface.nic.id]
  size                            = var.vm_size 
  admin_username                  = var.admin_username
  admin_password                  = var.admin_password
  disable_password_authentication = var.disable_password_authentication

  source_image_reference {
  publisher = var.publisher
  offer     = var.offer  
  sku       = var.sku
  version   = var.storage_version
  }

  os_disk {
  name                 = var.os_disk_name
  caching              = var.caching
  storage_account_type = var.managed_disk_type
  disk_size_gb         = var.disk_size_gb 
  }
}