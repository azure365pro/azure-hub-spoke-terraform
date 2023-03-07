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

variable "storage_account_name" {
  type = string
}

variable "account_tier" {
  type = string
}

variable "account_replication_type" {
  type = string
}

variable "storage_container_name" {
  type = string
}

variable "container_access_type" {
  type = string
}

variable "kafka_cluster_name" {
  type = string
}

variable "cluster_version" {
  type = string
}

variable "kafka_version" {
  type = string
}

variable "gw_username" {
  type = string
}

variable "gw_password" {
  type = string
}

variable "h_vm_size" {
  type = string
}

variable "w_vm_size" {
  type = string
}

variable "z_vm_size" {
  type = string
}

variable "nodes_username" {
  type = string
}

variable "nodes_password" {
  type = string
}

variable "number_of_disks_per_node" {
  type = string
}

variable "target_instance_count" {
  type = string
}

variable "tier" {
  type = string
}

variable "spoke1_vnet_id" {
  type = string
}

variable "h_subnet_id" {
  type = string
}

variable "w_subnet_id" {
  type = string
}

variable "z_subnet_id" {
  type = string
}





