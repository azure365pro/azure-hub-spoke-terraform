output "public_ip_address_id" {
  description = "The id of the newly created vNet"
  value       = azurerm_public_ip.pip.id
}