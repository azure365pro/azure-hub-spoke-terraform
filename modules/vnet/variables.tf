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

variable "delegations" {
  type = map(object({
    name             = string
    service_delegation = object({
      name    = string
      actions = list(string)
    })
  }))
  default = {
    delegation-appService = {
      name = "delegation-appService"
      service_delegation = {
        name    = "Microsoft.Web/serverFarms"
        actions = [
          "Microsoft.Network/virtualNetworks/subnets/action",
        ]
      }
    }
  }
}




