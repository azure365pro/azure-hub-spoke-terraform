# Postgresql Server - Flexible server

resource "azurerm_postgresql_flexible_server" "default" {
  name                   = var.postgresql_server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.postgresql_version
  delegated_subnet_id    = var.database_subnet_id
  private_dns_zone_id    = var.private_dns_zone_id
  administrator_login    = var.postgresql_server_username
  administrator_password = var.postgresql_server_password
  zone                   = "1"
  storage_mb             = var.postgresql_db_storage_size_mb
  sku_name               = var.postgresql_db_sql_sku
  backup_retention_days  = var.postgresql_db_database_backup_retention_days

}

resource "azurerm_postgresql_flexible_server_database" "default" {
  for_each            = var.postgresql_databases
  name                = each.value.postgresql_database_name  
  server_id           = azurerm_postgresql_flexible_server.default.id
  charset             = each.value.charset  
  collation           = each.value.collation
}

