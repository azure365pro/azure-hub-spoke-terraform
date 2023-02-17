variable "virtual_network_peering_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "virtual_network_name" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "remote_virtual_network_id" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "allow_virtual_network_access" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "allow_forwarded_traffic" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "allow_gateway_transit" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "use_remote_gateways" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}