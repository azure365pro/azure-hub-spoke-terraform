variable "route_table_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "location" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "resource_group_name" {

  description = "The full Azure resource ID of the remote virtual network."
}

variable "disable_bgp_route_propagation" {

  description = "The full Azure resource ID of the remote virtual network."
}

variable "route_name" {

  description = "The full Azure resource ID of the remote virtual network."
}

variable "address_prefix" {

  description = "The full Azure resource ID of the remote virtual network."
}



variable "next_hop_type" {

  description = "The full Azure resource ID of the remote virtual network."
}

variable "next_hop_in_ip_address" {

  description = "The full Azure resource ID of the remote virtual network."
}

variable "subnet_ids" {
  description = "The full Azure resource ID of the remote virtual network."
  default     = ""
}


