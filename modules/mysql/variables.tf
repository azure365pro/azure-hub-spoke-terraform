variable "mysql_server_name" {
  description = "MySQL DB Server name"
  default     = "wp-app-dbserver"
}

variable "database_subnet_id" {
  description = "MySQL DB Server name"
  default     = "wp-app-dbserver"
}

variable "private_dns_zone_id" {
  description = "MySQL DB Server name"
  default     = "wp-app-dbserver"
}

variable "location" {
  type = string
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group in which to create the virtual network peering."
}

variable "mysql_db_sql_sku" {
  description = "SQL SKU Size"
  default     = "GP_Standard_D2ds_v4"
}

variable "mysql_db_database_version" {
  description = "SQL DB Version"
  default     = "8.0.21"
}

variable "mysql_db_database_backup_retention_days" {
  description = "how long to keep MySQL backup"
  default     = "7"
}

variable "mysql_db_database_georedundant_backup" {
  description = "Geo-Redundant Backup Enabled"
  default     = "false"
}


variable "mysql_server_username" {
  description = "DB Server Username"
  default     = "wpdbadmusr"
}

variable "mysql_server_password" {
  description = "DB Server Password"
  sensitive   = true
}

variable "mysql_db_storage_size_gb" {
  description = "SQL DB Storage Size"
  default     = "128"
}

variable "mysql_db_storage_iops" {
  description = "SQL DB Storage IOPS"
  default     = "700"
}

variable "mysql_databases" {
  description = "WP DB name"
  default     = "wp-app-database"
}