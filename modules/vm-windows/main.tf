resource "azurerm_network_interface" "nic" {
  name                = var.nic_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = var.ipconfig_name
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = var.private_ip_address_allocation
    private_ip_address            = var.private_ip_address
    public_ip_address_id          = var.public_ip_address_id
  }
}
resource "azurerm_virtual_machine" "vm" {
  name                  = var.virtual_machine_name
  location              = var.location
  resource_group_name   = var.resource_group_name
  network_interface_ids = [azurerm_network_interface.nic.id]
  vm_size               = var.vm_size 

  # Uncomment this line to delete the OS disk automatically when deleting the VM
  delete_os_disk_on_termination = var.delete_os_disk_on_termination

  # Uncomment this line to delete the data disks automatically when deleting the VM
  delete_data_disks_on_termination = var.delete_data_disks_on_termination

  storage_image_reference {
    publisher = var.publisher
    offer     = var.offer  
    sku       = var.sku
    version   = var.storage_version
  }
  storage_os_disk {
    name              = var.os_disk_name
    caching           = var.caching
    create_option     = var.create_option
    managed_disk_type = var.managed_disk_type
  }
  os_profile {
    computer_name  =  var.virtual_machine_name
    admin_username =  var.admin_username
    admin_password =  var.admin_password
  }
  os_profile_windows_config {
  provision_vm_agent = var.provision_vm_agent
}
}