output "nic_id" {
  description = "The id of the newly created nsg"
  value       = azurerm_network_interface.nic.id
}