resource "azurerm_firewall" "az-firewall" {
  name                = var.azure_firewall_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku_name            = var.sku_name
  sku_tier            = var.sku_tier
  # Associating Azure Firewall with Firewall Manager Policy
  firewall_policy_id  = azurerm_firewall_policy.az-firewall-pol01.id

  ip_configuration {
    name                 = var.ipconfig_name
    subnet_id            = var.subnet_id
    public_ip_address_id = var.public_ip_address_id
  }
}

#Firewall Policy
resource "azurerm_firewall_policy" "az-firewall-pol01" {
  name                = var.azure_firewall_policy_name
  location            = var.location
  resource_group_name = var.resource_group_name
  
}

# Firewall Policy Rules
resource "azurerm_firewall_policy_rule_collection_group" "az-collection-pol01" {
  name               = var.azure_firewall_policy_coll_group_name
  firewall_policy_id = azurerm_firewall_policy.az-firewall-pol01.id
  priority           = var.priority
  
  network_rule_collection {
  name     = var.network_rule_coll_name_01
  priority = var.network_rule_coll_priority_01
  action   = var.network_rule_coll_action_01
    dynamic "rule" {
        for_each = var.network_rules_01
            content {
                name                  = rule.value.name
                source_addresses      = rule.value.source_addresses
                destination_addresses = rule.value.destination_addresses
                destination_ports     = rule.value.destination_ports
                protocols             = rule.value.protocols
            }
    }
  }
  
  network_rule_collection {
  name     = var.network_rule_coll_name_02
  priority = var.network_rule_coll_priority_02
  action   = var.network_rule_coll_action_02
    dynamic "rule" {
        for_each = var.network_rules_02
            content {
                name                  = rule.value.name
                source_addresses      = rule.value.source_addresses
                destination_addresses = rule.value.destination_addresses
                destination_ports     = rule.value.destination_ports
                protocols             = rule.value.protocols
            }
    }
  }

  application_rule_collection {
  name     = var.application_rule_coll_name
  priority = var.application_rule_coll_priority
  action   = var.application_rule_coll_action
    dynamic "rule" {
      for_each = var.application_rules
      content {      
      name = rule.value.name
      source_addresses  = rule.value.source_addresses
      destination_fqdns = rule.value.destination_fqdns
    dynamic "protocols" {
      for_each = var.application_protocols
      content {
        type = protocols.value.type
        port = protocols.value.port
      }
    }

    }
  }
}

    nat_rule_collection {
    name            = var.dnat_rule_coll_name
    priority        = var.dnat_rule_coll_priority
    action          = var.dnat_rule_coll_action
    
    dynamic "rule" {
      for_each = var.dnat_rules
      content {
        name               = rule.value.name
        /**
        source_addresses   = rule.value.source_addresses
        destination_ports  = rule.value.destination_ports
        translated_address = rule.value.translated_address
        translated_port    = rule.value.translated_port
        protocols          = rule.value.protocols       
        **/
      protocols           = rule.value.protocols
      source_addresses    = rule.value.source_addresses
      destination_address = rule.value.destination_address
      destination_ports   = rule.value.destination_ports
      translated_address  = rule.value.translated_address
      translated_port     = rule.value.translated_port
      }
    }
  }
}