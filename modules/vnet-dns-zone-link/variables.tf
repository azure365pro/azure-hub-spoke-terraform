variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "vnet_dns_zone_link_name" {
  description = "vnet_dns_zone_link_name"
}

variable "private_dns_zone_name" {
  description = "private_dns_zone_name"
  default     = "wp-app-web"
}

variable "virtual_network_id" {
  description = "virtual_network_id"

}