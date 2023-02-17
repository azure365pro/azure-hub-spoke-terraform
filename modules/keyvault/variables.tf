variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "location" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "managed_identity_name" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "key_vault_name" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "sku_name" {
  type        = string
  description = "The full Azure resource ID of the remote virtual network."
}

variable "admin_certificate_permissions" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "admin_key_permissions" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "admin_secret_permissions" {
  description = "The full Azure resource ID of the remote virtual network."
}

variable "managed_identity_secret_permissions" {
  description = "The full Azure resource ID of the remote virtual network."
}