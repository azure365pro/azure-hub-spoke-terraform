resource "azurerm_linux_web_app" "linux_web_app" {
  /**
  app_settings = {
    WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
    WEBSITE_NODE_DEFAULT_VERSION       = var.node_version
  }
 **/
  app_settings = merge(
    {
      WEBSITES_ENABLE_APP_SERVICE_STORAGE = "true"
    },
    var.runtime == "nodejs" ? { WEBSITE_NODE_DEFAULT_VERSION = var.node_version } : {},
    #var.runtime == "php" ? { WEBSITE_PHP_VERSION = var.php_version } : {},
  )

  location                  = var.location
  name                      = var.web_app_name
  resource_group_name       = var.resource_group_name
  service_plan_id           = var.service_plan_id 
  virtual_network_subnet_id = var.subnet_id
  client_affinity_enabled   = false
  site_config {
    ftps_state             = "AllAllowed"
    always_on              = var.app_service_alwayson
    vnet_route_all_enabled = true
    
    dynamic "application_stack" {
      for_each = var.runtime == "php" ? [1] : []
      content {
        php_version = var.php_version
      }
    }
  }
}