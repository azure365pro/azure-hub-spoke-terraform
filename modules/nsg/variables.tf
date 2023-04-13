variable "nsg_name" {
  type = string
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "location" {
  type = string
}

variable "nsg-rules" {
  type = map
}