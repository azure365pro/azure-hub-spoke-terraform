output "public_ip_address_id" {
  description = "The id of the newly created vNet"
  value       = azurerm_public_ip.pip.id
}

output "public_ip_address" {
  description = "The public IP address"
  value       = azurerm_public_ip.pip.ip_address
}