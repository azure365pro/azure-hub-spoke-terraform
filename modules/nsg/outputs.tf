output "nsg_id" {
  description = "The id of the newly created nsg"
  value       = azurerm_network_security_group.nsg.id
}