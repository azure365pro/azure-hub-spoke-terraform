variable "network_interface_id" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "network_security_group_id" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}