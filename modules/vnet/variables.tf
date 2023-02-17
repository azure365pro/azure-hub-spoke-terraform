variable "virtual_network_name" {
  type = string
}

variable "resource_group_name" {
  type = string
}

variable "location" {
  type = string
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "virtual_network_address_space" {
  description = "name of the virtual network"
}

variable "subnet_names" {
  description = "name of the virtual network"
}




