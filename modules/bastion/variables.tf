variable "bastion_host_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "location" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "ipconfig_name" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "subnet_id" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "public_ip_address_id" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "tags" {
  type    = map(string)
  default = {}
}