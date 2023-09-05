variable "postgresql_server_name" {
  description = "MySQL DB Server name"
  default     = "wp-app-dbserver"
}

variable "resource_group_name" {
  description = "MySQL DB Server name"
  default     = "wp-app-dbserver"
}

variable "location" {
  description = "MySQL DB Server name"
  default     = "wp-app-dbserver"
}

variable "postgresql_version" {

}

variable "database_subnet_id" {
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "private_dns_zone_id" {
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "postgresql_server_username" {
  description = "SQL SKU Size"
}

variable "postgresql_server_password" {
  description = "SQL DB Version"
}

variable "postgresql_db_storage_size_mb" {
  description = "how long to keep MySQL backup"
}

variable "postgresql_db_sql_sku" {
  description = "Geo-Redundant Backup Enabled"
}

variable "postgresql_db_database_backup_retention_days" {
  description = "DB Server Username"
}

variable "postgresql_databases" {
  description = "DB Server Password"
}
