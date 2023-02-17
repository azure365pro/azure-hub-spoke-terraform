locals {
  default_tags = {}
  all_tags     = merge(local.default_tags, var.az_tags)
}

# Resource Group

resource "azurerm_resource_group" "az-rg" {
  name     = var.az_rg_name
  location = var.az_rg_location

  tags = local.all_tags
}
