#MySQL Server - Flexible server
resource "azurerm_mysql_flexible_server" "mysql_db_server" {
  name                         = var.mysql_server_name
  delegated_subnet_id          = var.database_subnet_id
  private_dns_zone_id          = var.private_dns_zone_id
  location                     = var.location
  resource_group_name          = var.resource_group_name
  sku_name                     = var.mysql_db_sql_sku
  version                      = var.mysql_db_database_version
  backup_retention_days        = var.mysql_db_database_backup_retention_days
  geo_redundant_backup_enabled = var.mysql_db_database_georedundant_backup
  administrator_login          = var.mysql_server_username
  administrator_password       = var.mysql_server_password
  zone                        = 2
  storage {
    size_gb = var.mysql_db_storage_size_gb
    iops    = var.mysql_db_storage_iops
  }
}

resource "azurerm_mysql_flexible_database" "mysql_database" {
  for_each = var.mysql_databases
  name                = each.value.mysql_database_name  
  resource_group_name = var.resource_group_name
  server_name         = azurerm_mysql_flexible_server.mysql_db_server.name
  charset             = each.value.charset  
  collation           = each.value.collation
}