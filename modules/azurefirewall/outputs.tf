output "azure_firewall_private_ip" {
  description = "The id of the newly created vNet"
  value       = azurerm_firewall.az-firewall.ip_configuration[0].private_ip_address
}