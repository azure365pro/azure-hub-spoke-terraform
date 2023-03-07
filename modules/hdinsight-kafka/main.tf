resource "azurerm_storage_account" "storage_account" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = var.account_tier  
  account_replication_type = var.account_replication_type
}

resource "azurerm_storage_container" "storage_container" {
  name                     = var.storage_container_name
  storage_account_name     = azurerm_storage_account.storage_account.name
  container_access_type    = var.container_access_type 
}

resource "azurerm_hdinsight_kafka_cluster" "kafka_cluster" {
  name                = var.kafka_cluster_name
  resource_group_name = var.resource_group_name
  location            = var.location
  cluster_version     = var.cluster_version
  tier                = var.tier

  component_version {
    kafka = var.kafka_version
  }

  gateway {
    username = var.gw_username
    password = var.gw_password
  }

  storage_account {
    storage_container_id = azurerm_storage_container.storage_container.id
    storage_account_key  = azurerm_storage_account.storage_account.primary_access_key
    is_default           = true
  }

  roles {
    head_node {
      vm_size                   = var.h_vm_size
      username                  = var.nodes_username
      password                  = var.nodes_password 
      virtual_network_id        = var.spoke1_vnet_id  
      subnet_id                 = var.h_subnet_id  
    }

    worker_node {
      vm_size                   = var.w_vm_size
      username                  = var.nodes_username
      password                  = var.nodes_password 
      number_of_disks_per_node  = var.number_of_disks_per_node 
      target_instance_count     = var.target_instance_count
      virtual_network_id        = var.spoke1_vnet_id  
      subnet_id                 = var.w_subnet_id  
    }

    zookeeper_node {
      vm_size                   = var.z_vm_size
      username                  = var.nodes_username
      password                  = var.nodes_password 
      virtual_network_id        = var.spoke1_vnet_id  
      subnet_id                 = var.z_subnet_id 
    }
  }
}