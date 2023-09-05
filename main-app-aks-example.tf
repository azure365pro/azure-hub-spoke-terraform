/**
# if you are running Against new Subscription 
# az provider register --namespace Microsoft.OperationalInsights
# az provider register --namespace Microsoft.OperationsManagement
# az provider register --namespace Microsoft.ContainerService
# az provider register --namespace Microsoft.Web
# az provider register --namespace Microsoft.Cache
# az feature register --namespace "Microsoft.Compute" --name "EncryptionAtHost"

# 
# To Check status - Usually Takes time
# az feature show --namespace "Microsoft.Compute" --name "EncryptionAtHost" 
# 

# 
# Depends on is a bug in AKS Module
# it has to be commented on line 465 after the intial commit otherwise 
# any change in code it will try to recreate AKS Cluster

#  Deviations from Terraform - Manual Steps
# - App Settings Variables
# - Redis cache private dns integration
# - Acr private endpoints
# - Securing secrets of redis and api keys in pipelines
# - Enable Key vault service in vnet / subnets
# - Configuring Managed Identities for Key Vault and AKS

# Resource Group Module is Used to Create Resource Groups
module "hub-resourcegroup" {
source = "./modules/resourcegroups"
# Resource Group Variables
az_rg_name      = "az-conn-pr-eus-net-rg"
az_rg_location  = "eastus"
az_tags = {
ApplicationName = "Network"
Role 		        = "Network"
Owner 		      = "IT"
Environment	    = "Prod"
CompanyName     = "FULC"
Criticality     = "Medium"
DR 		          = "No"
  }
}

# Resource Group Module is Used to Create Resource Groups
module "spoke1-resourcegroup" {
source = "./modules/resourcegroups"
# Resource Group Variables
az_rg_name     = "az-365pro-pr-eus-aks-rg"
az_rg_location = "eastus"
az_tags = {
ApplicationName = "Network"
Role 		        = "Network"
Owner 		      = "IT"
Environment	    = "Prod"
CompanyName     = "FULC"
Criticality     = "Medium"
DR 		          = "No"
  }
}

module "spoke1-app-resourcegroup" {
source = "./modules/resourcegroups"
# Resource Group Variables
az_rg_name     = "az-365pro-pr-eus-app-rg"
az_rg_location = "eastus"
az_tags = {
ApplicationName = "Network"
Role 		    = "Network"
Owner 		    = "IT"
Environment	    = "Prod"
CompanyName     = "FULC"
Criticality     = "Medium"
DR 		        = "No"
  }
}

module "spoke1-db-resourcegroup" {
source = "./modules/resourcegroups"
# Resource Group Variables
az_rg_name     = "az-365pro-pr-eus-db-rg"
az_rg_location = "eastus"
az_tags = {
ApplicationName = "Network"
Role 		    = "Network"
Owner 		    = "IT"
Environment	    = "Prod"
CompanyName     = "FULC"
Criticality     = "Medium"
DR 		        = "No"
  }
}

module "hub-afd-resourcegroup" {
source = "./modules/resourcegroups"
# Resource Group Variables
az_rg_name     = "az-365pro-pr-eus-afd-rg"
az_rg_location = "eastus"
az_tags = {
ApplicationName = "Network"
Role 		    = "Network"
Owner 		    = "IT"
Environment	    = "Prod"
CompanyName     = "FULC"
Criticality     = "Medium"
DR 		        = "No"
  }
}

module "jmp-box-resourcegroup" {
source = "./modules/resourcegroups"
# Resource Group Variables
az_rg_name     = "az-365pro-pr-eus-jmp-rg"
az_rg_location = "eastus"
az_tags = {
ApplicationName = "Network"
Role 		    = "Network"
Owner 		    = "IT"
Environment	    = "Prod"
CompanyName     = "FULC"
Criticality     = "Medium"
DR 		        = "No"
  }
}

# vnet Module is used to create Virtual Networks and Subnets
module "hub-vnet" {
source = "./modules/vnet"

virtual_network_name              = "az-conn-pr-eus-vnet"
resource_group_name               = module.hub-resourcegroup.rg_name
location                          = module.hub-resourcegroup.rg_location
virtual_network_address_space     = ["10.50.0.0/16"]
# Subnets are used in Index for other modules to refer
# module.hub-vnet.vnet_subnet_id[0] =  Azure firewall
subnet_names = {
    "AzureFirewallSubnet" = {
        subnet_name = "AzureFirewallSubnet"
        address_prefixes = ["10.50.1.0/24"]
        route_table_name = ""
        snet_delegation  = ""
    },
}
}

# vnet Module is used to create Virtual Networks and Subnets
module "spoke1-vnet" {
source = "./modules/vnet"

virtual_network_name              = "az-365pro-pr-eus-vnet"
resource_group_name               = module.spoke1-resourcegroup.rg_name
location                          = module.spoke1-resourcegroup.rg_location
virtual_network_address_space     = ["10.51.0.0/16"]
#     "az-365pro-pr-acr-snet"   = 	0
#     "az-365pro-pr-aks-snet"   = 	1
#     "az-365pro-pr-db-snet"    = 	2
#     "az-365pro-pr-jmp-snet"   = 	3
#     "az-365pro-pr-redis-snet" = 	4
#     "az-365pro-pr-web-snet"   = 	5

subnet_names = {
    "az-365pro-pr-web-snet" = {
        subnet_name = "az-365pro-pr-web-snet"
        address_prefixes = ["10.51.1.0/24"]
        route_table_name = "" 
        snet_delegation  = "appservice"   
    },
    "az-365pro-pr-db-snet" = {
        subnet_name = "az-365pro-pr-db-snet"
        address_prefixes = ["10.51.2.0/24"]
        route_table_name = ""
        snet_delegation  = "postgresql"
    }
    "az-365pro-pr-redis-snet" = {
        subnet_name = "az-365pro-pr-redis-snet"
        address_prefixes = ["10.51.3.0/24"]
        route_table_name = ""
        snet_delegation  = ""
    },
    "az-365pro-pr-jmp-snet" = {
        subnet_name = "az-365pro-pr-jmp-snet"
        address_prefixes = ["10.51.4.0/24"]
        route_table_name = ""
        snet_delegation  = ""
    },
    "az-365pro-pr-acr-snet" = {
        subnet_name = "az-365pro-pr-acr-snet"
        address_prefixes = ["10.51.5.0/24"]
        route_table_name = ""
        snet_delegation  = ""
    },
    #10k Available IPs
    "az-365pro-pr-aks-snet" = {
        subnet_name = "az-365pro-pr-aks-snet"
        address_prefixes = ["10.51.192.0/18"]
        route_table_name = ""
        snet_delegation  = ""
    }
   }
}

# vnet-peering Module is used to create peering between Virtual Networks
module "hub-to-spoke1" {
source = "./modules/vnet-peering"
depends_on = [module.hub-vnet , module.spoke1-vnet , module.azure_firewall_01]
#depends_on = [module.hub-vnet , module.spoke1-vnet , module.application_gateway, module.vpn_gateway , module.azure_firewall_01]

virtual_network_peering_name = "az-conn-pr-eus-vnet-to-az-365pro-pr-eus-vnet"
resource_group_name          = module.hub-resourcegroup.rg_name
virtual_network_name         = module.hub-vnet.vnet_name
remote_virtual_network_id    = module.spoke1-vnet.vnet_id
allow_virtual_network_access = "true"
allow_forwarded_traffic      = "true"
allow_gateway_transit        = "true"
use_remote_gateways          = "false"
}

# vnet-peering Module is used to create peering between Virtual Networks
module "spoke1-to-hub" {
source = "./modules/vnet-peering"

virtual_network_peering_name = "az-365pro-pr-eus-vnet-to-az-conn-pr-eus-vnet"
resource_group_name          = module.spoke1-resourcegroup.rg_name
virtual_network_name         = module.spoke1-vnet.vnet_name
remote_virtual_network_id    = module.hub-vnet.vnet_id
allow_virtual_network_access = "true"
allow_forwarded_traffic      = "true"
allow_gateway_transit        = "false"
# As there is no gateway while testing - Setting to False
#use_remote_gateways   = "true"
use_remote_gateways          = "false"
depends_on = [module.hub-vnet , module.spoke1-vnet]
}

# routetables Module is used to create route tables and associate them with Subnets created by Virtual Networks
module "route_tables" {
source = "./modules/routetables"
depends_on = [module.hub-vnet , module.spoke1-vnet]

route_table_name              = "az-365pro-pr-eus-route"
location                      = module.hub-resourcegroup.rg_location
resource_group_name           = module.hub-resourcegroup.rg_name
disable_bgp_route_propagation = false

route_name                    = "ToAzureFirewall"
address_prefix                = "0.0.0.0/0"
next_hop_type                 = "VirtualAppliance"
next_hop_in_ip_address        = module.azure_firewall_01.azure_firewall_private_ip

  subnet_ids                    = [
   module.spoke1-vnet.vnet_subnet_id[0],
   module.spoke1-vnet.vnet_subnet_id[1],
   module.spoke1-vnet.vnet_subnet_id[2],
   module.spoke1-vnet.vnet_subnet_id[3],
   module.spoke1-vnet.vnet_subnet_id[4],
   module.spoke1-vnet.vnet_subnet_id[5]    
  ]
}


# publicip Module is used to create Public IP Address
module "public_ip_03" {
source = "./modules/publicip"

# Used for Azure Firewall 
public_ip_name      = "az-conn-pr-eus-afw-pip03"
resource_group_name = module.hub-resourcegroup.rg_name
location            = module.hub-resourcegroup.rg_location
allocation_method   = "Static"
sku                 = "Standard"
}

# azurefirewall Module is used to create Azure Firewall 
# Firewall Policy
# Associate Firewall Policy with Azure Firewall
# Network and Application Firewall Rules 
module "azure_firewall_01" {
source = "./modules/azurefirewall"
depends_on = [module.hub-vnet]

  azure_firewall_name = "az-conn-pr-eus-afw"
  location            = module.hub-resourcegroup.rg_location
  resource_group_name = module.hub-resourcegroup.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ipconfig_name        = "configuration"
  subnet_id            = module.hub-vnet.vnet_subnet_id[0]
  public_ip_address_id = module.public_ip_03.public_ip_address_id

  azure_firewall_policy_coll_group_name  = "az-conn-pr-eus-afw-coll-pol01" 
  azure_firewall_policy_name             = "az-conn-pr-eus-afw-pol01"  
  priority                               = 100

  network_rule_coll_name_01     = "Blocked_Network_Rules"
  network_rule_coll_priority_01 = "2000"
  network_rule_coll_action_01   = "Deny"
  network_rules_01 = [   
        {    
            name                  = "Blocked_rule_1"
            source_addresses      = ["10.1.0.0/16"]
            destination_addresses = ["10.8.8.8", "8.10.4.4"]
            destination_ports     = [11]
            protocols             = ["TCP"]
        },
        {      
            name                  = "Blocked_rule_2"
            source_addresses      = ["10.1.0.0/16"]
            destination_addresses = ["10.8.8.8", "8.10.4.4"]
            destination_ports     = [21]
            protocols             = ["TCP"]
        },
                {    
            name                  = "Blocked_rule_3"
            source_addresses      = ["10.1.0.0/16"]
            destination_addresses = ["10.8.8.8", "8.10.4.4"]
            destination_ports     = [11]
            protocols             = ["TCP"]
        },
        {      
            name                  = "Blocked_rule_4"
            source_addresses      = ["10.1.0.0/16"]
            destination_addresses = ["10.8.8.8", "8.10.4.4"]
            destination_ports     = [21]
            protocols             = ["TCP"]
        }
    ]  

  network_rule_coll_name_02     = "Allowed_Network_Rules"
  network_rule_coll_priority_02 = "3000"
  network_rule_coll_action_02   = "Allow"
  network_rules_02 = [   
        {    
            name                  = "Allowed_Network_rule_1"
            source_addresses      = ["10.1.0.0/16"]
            destination_addresses = ["172.21.1.10", "8.10.4.4"]
            destination_ports     = [11]
            protocols             = ["TCP"]
        },
        {      
            name                  = "Allowed_Network_rule_2"
            source_addresses      = ["10.1.0.0/16"]
            destination_addresses = ["172.21.1.10", "8.10.4.4"]
            destination_ports     = [21]
            protocols             = ["TCP"]
        },
        {    
            name                  = "Allowed_Network_rule_3"
            source_addresses      = ["10.1.0.0/16"]
            destination_addresses = ["172.21.1.10", "8.10.4.4"]
            destination_ports     = [11]
            protocols             = ["TCP"]
        },
        {      
            name                  = "Allowed_Network_rule_4"
            source_addresses      = ["10.1.0.0/16"]
            destination_addresses = ["172.21.1.10", "8.10.4.4"]
            destination_ports     = [21]
            protocols             = ["TCP"]
        },
        {      
            name                  = "Allowed_Network_rule_AKS"
            source_addresses      = ["10.51.192.0/18"]
            destination_addresses = ["*"]
            destination_ports     = ["*"]
            protocols             = ["TCP","UDP"]
        },
        {      
            name                  = "Allowed_Network_rule_web"
            source_addresses      = ["10.51.1.0/24"]
            destination_addresses = ["*"]
            destination_ports     = ["*"]
            protocols             = ["TCP","UDP"]
        }
    ]  


 application_rule_coll_name     = "Allowed_websites"
 application_rule_coll_priority = "4000"
 application_rule_coll_action   = "Allow"
 application_rules = [   
        # {    
        #     name                  = "Allowed_website_01"
        #     source_addresses      = ["*"]
        #     destination_fqdns     = ["bing.co.uk"]
        # },
        # {    
        #     name                  = "Allowed_website_02"
        #     source_addresses      = ["*"]
        #     destination_fqdns     = ["*.bing.com"]
        # }, 
        {    
            name                  = "Allowed_website_03"
            source_addresses      = ["*"]
            destination_fqdns     = ["*"]
        }

    ]  
 application_protocols = [   
        {    
            type = "Http"
            port = 80
        },
        {
            type = "Https"
            port = 443
        }
    ]
 dnat_rule_coll_name     = "DNATCollection"
 dnat_rule_coll_priority = "1000"
 dnat_rule_coll_action   = "Dnat"
 dnat_rules = [
  {     
      name                = "DNATRuleRDP"
      protocols           = ["TCP"]
      source_addresses    = ["*"]
      destination_address = module.public_ip_03.public_ip_address
      destination_ports   = ["3389"]
      translated_address  = "10.51.4.4"
      translated_port     = "3389"
      
      # name                = "nat_rule_collection1_rule1"
      # protocols           = ["TCP", "UDP"]
      # source_addresses    = ["10.0.0.1", "10.0.0.2"]
      # destination_address = "192.168.1.1"
      # destination_ports   = ["80"]
      # translated_address  = "192.168.0.1"
      # translated_port     = "8080"
      
  },
  # Add more DNAT rules as needed
]

} 

data "azuread_group" "admin-team" {
  display_name     = "aks-admins"
  # Security Group Exists named aks-admins
}


module "aks" {

  source                            = "Azure/aks/azurerm"
  version                           = "7.3.1"
  resource_group_name               = module.spoke1-resourcegroup.rg_name
  kubernetes_version                = "1.26.6"
  orchestrator_version              = "1.26.6"
  prefix                            = "az-365pro-pr-aks"
  cluster_name                      = "az-365pro-pr-aks-cluster"
  vnet_subnet_id                    = module.spoke1-vnet.vnet_subnet_id[1]
  network_plugin                    = "azure"
  os_disk_size_gb                   = 50
  role_based_access_control_enabled = true
  rbac_aad_admin_group_object_ids   = [data.azuread_group.admin-team.id]
  rbac_aad_managed                  = true
  //enable_azure_policy              = true # calico.. etc
  enable_auto_scaling               = true
  enable_host_encryption            = true
  agents_min_count                  = 1
  agents_max_count                  = 2
  agents_count                      = null # Please set `agents_count` `null` while `enable_auto_scaling` is `true` to avoid possible `agents_count` changes.
  agents_max_pods                   = 100
  agents_pool_name                  = "agentpool"
  agents_availability_zones         = ["1", "2", "3"]
  agents_type                       = "VirtualMachineScaleSets"
  agents_size                       = "Standard_DS2_v2"


  agents_labels = {
    "agentpool" : "agentpool"
  }

  
  agents_tags = {
    "Agent" : "defaultnodepoolagent"
  }
# Depends on is a killer when you add / remove subnets - It may recreate the cluster
  depends_on = [module.spoke1-vnet, module.azure_firewall_01]
}

module "app-service-plan" {
source = "./modules/appservice"

resource_group_name               = module.spoke1-app-resourcegroup.rg_name
location                          = module.spoke1-app-resourcegroup.rg_location
app_service_hosting_plan_name     = "az-365pro-appsvc-plan"
app_service_hosting_plan_sku      = "P1v2"
os_type                           = "Linux"

depends_on = [module.spoke1-vnet]

}

module "app-service-prod" {
source = "./modules/appservice-linux"

resource_group_name               = module.spoke1-app-resourcegroup.rg_name
location                          = module.spoke1-app-resourcegroup.rg_location
service_plan_id                   = module.app-service-plan.service_plan_id
subnet_id                         = module.spoke1-vnet.vnet_subnet_id[5]
web_app_name                      = "az-365pro-prod"
runtime                           = "nodejs"
node_version                      = "NODE|18-lts"
# if you want to switch to php comment above
#runtime                           = "php"
#php_version                       = "8.0"

depends_on = [module.spoke1-vnet, module.app-service-plan]

}

module "dns-zone" {
source = "./modules/dns-zone"

resource_group_name               = module.spoke1-app-resourcegroup.rg_name
private_dns_zone_name             = "private-dns.fulc.internal"

}

module "vnet-dns-zone-link" {
source = "./modules/vnet-dns-zone-link"

resource_group_name               = module.spoke1-app-resourcegroup.rg_name
vnet_dns_zone_link_name           = "private-dns.fulc.internal-vnetlink"
private_dns_zone_name             = module.dns-zone.dns_zone_name
virtual_network_id                = module.spoke1-vnet.vnet_id
registration_enabled              = "false"

depends_on = [module.spoke1-vnet, module.dns-zone]
}

module "dns-zone-postgres" {
source = "./modules/dns-zone"

resource_group_name               = module.spoke1-app-resourcegroup.rg_name
private_dns_zone_name             = "privatelink.postgres.database.azure.com"

}

module "vnet-dns-zone-postgres-link" {
source = "./modules/vnet-dns-zone-link"

resource_group_name               = module.spoke1-app-resourcegroup.rg_name
vnet_dns_zone_link_name           = "private-dns.fulc.azure.com-vnetlink"
private_dns_zone_name             = module.dns-zone-postgres.dns_zone_name
virtual_network_id                = module.spoke1-vnet.vnet_id
registration_enabled              = "false"

depends_on = [module.spoke1-vnet, module.dns-zone-postgres]
}

module "dns-zone-redis" {
source = "./modules/dns-zone"

resource_group_name               = module.spoke1-app-resourcegroup.rg_name
private_dns_zone_name             = "privatelink.redis.cache.windows.net"

}

module "vnet-dns-zone-redis-link" {
source = "./modules/vnet-dns-zone-link"

resource_group_name               = module.spoke1-app-resourcegroup.rg_name
vnet_dns_zone_link_name           = "private-dns.fulc.azure.com-vnetlink"
private_dns_zone_name             = module.dns-zone-redis.dns_zone_name
virtual_network_id                = module.spoke1-vnet.vnet_id
registration_enabled              = "false"

depends_on = [module.spoke1-vnet, module.dns-zone-redis]
}


module "redis" {
source = "./modules/redis"

resource_group_name               = module.spoke1-app-resourcegroup.rg_name
location                          = module.spoke1-app-resourcegroup.rg_location
redis_name                        = "az-365pro-prod-redis"
capacity                          = 0
family                            = "C"
sku_name                          = "Basic"
enable_non_ssl_port               = false
minimum_tls_version               = "1.2"

depends_on = [module.spoke1-vnet, module.dns-zone, module.vnet-dns-zone-link]
}



module "pvt-endpoint" {
source = "./modules/pvt-endpoint"

  pvt_endpoint_name                = "az-365pro-prod-redis-pe"
  resource_group_name              = module.spoke1-app-resourcegroup.rg_name
  location                         = module.spoke1-app-resourcegroup.rg_location
  subnet_id                        = module.spoke1-vnet.vnet_subnet_id[4] 
  private_service_connection_name  = "az-365pro-prod-redis-pe-connection"
  is_manual_connection             = false
  private_connection_resource_id   = module.redis.redis_cache_id
  subresource_name                 = "redisCache"

depends_on = [module.spoke1-vnet, module.dns-zone, module.vnet-dns-zone-link , module.redis]
}

module "postgresql-01" {
source = "./modules/postgresql"

  postgresql_server_name                        = "az-365pro-pr-dbserver"
  resource_group_name                           = module.spoke1-db-resourcegroup.rg_name
  location                                      = module.spoke1-db-resourcegroup.rg_location
  postgresql_version                            = "15"
  database_subnet_id                            = module.spoke1-vnet.vnet_subnet_id[1] 
  private_dns_zone_id                           = module.dns-zone-postgres.dns_zone_id
  postgresql_server_username                    = "dbadmin"
  postgresql_server_password                    = "fulc-*1234*2932"
  postgresql_db_storage_size_mb                 = 32768
  postgresql_db_sql_sku                         = "GP_Standard_D2s_v3"
  postgresql_db_database_backup_retention_days  = 7

  postgresql_databases = {
    "fulcdb" = {
  postgresql_database_name                = "fulcdb"
  charset                                 = "UTF8" 
  collation                               = "en_US.utf8"  
    }
  #   ,
  #   "testdb2" = {
  # mysql_database_name                     = "testdb2"
  # charset                                 = "utf8mb3"
  # collation                               = "utf8mb3_general_ci" 
  #   }
  #   "testdb3" = {
  # mysql_database_name                     = "testdb3"
  # charset                                 = "utf8mb3"
  # collation                               = "utf8mb3_general_ci" 
  #   }
  #   
  }

depends_on = [module.spoke1-vnet, module.dns-zone-postgres, module.vnet-dns-zone-postgres-link , module.redis]
}

# - Not Needed as DNAT happening from Azure Firewall
# # publicip Module is used to create Public IP Address
# module "public_ip_01" {
# source = "./modules/publicip"

# # Used for Jump Box
# public_ip_name      = "az-jmp-pr-eastus-pip01"
# resource_group_name = module.jmp-box-resourcegroup.rg_name
# location            = module.jmp-box-resourcegroup.rg_location
# allocation_method   = "Static"
# sku                 = "Standard"
# }


module "vm-jumpbox-01" {
source = "./modules/vm-windows"
virtual_machine_name             = "azjump01"
nic_name                         = "azjump01-nic"
location                         = module.jmp-box-resourcegroup.rg_location
resource_group_name              = module.jmp-box-resourcegroup.rg_name
ipconfig_name                    = "ipconfig1"
subnet_id                        = module.spoke1-vnet.vnet_subnet_id[3]
private_ip_address_allocation    = "Static" # Dynamic
private_ip_address               = "10.51.4.4"
vm_size                          = "Standard_D8s_v3" #Standard_D2s_v3
# Uncomment this line to delete the OS disk automatically when deleting the VM
delete_os_disk_on_termination    = true
# Uncomment this line to delete the data disks automatically when deleting the VM
delete_data_disks_on_termination = true

publisher                        = "MicrosoftWindowsDesktop"
offer                            = "windows-11"
sku                              = "win11-22h2-pro"
storage_version                  = "latest"

os_disk_name                     = "azjump01osdisk"
caching                          = "ReadWrite"
create_option                    = "FromImage"
managed_disk_type                = "Premium_LRS"

admin_username                   = "az.admin"
admin_password                   = "Password1234!fulc"

provision_vm_agent               = true

#public_ip_address_id             = module.public_ip_01.public_ip_address_id

depends_on = [module.spoke1-vnet ]
}

module "nsg" {
source = "./modules/nsg"

# Used for Jump Box
nsg_name                         = "az-jmp-pr-eastus-nsg"
resource_group_name              = module.jmp-box-resourcegroup.rg_name
location                         = module.jmp-box-resourcegroup.rg_location

nsg-rules = {   
       "nsg-rule-01" = {    
              name                        = "RDP_Inbound"
              priority                    = "100"
              direction                   = "Inbound"
              access                      = "Allow"
              protocol                    = "Tcp"
              source_port_range           = "*"
              destination_port_range      = "3389"
              source_address_prefix       = "*"
              destination_address_prefix  = "*"
        }
} 
# Visual Studio: Ctrl+K, Ctrl+C to comment; Ctrl+K, Ctrl+U to uncomment.
# nsg-rules = {   
#        "nsg-rule-01" = {    
#               name                        = "Outbound_Test"
#               priority                    = "100"
#               direction                   = "Outbound"
#               access                      = "Allow"
#               protocol                    = "Tcp"
#               source_port_range           = "*"
#               destination_port_range      = "*"
#               source_address_prefix       = "*"
#               destination_address_prefix  = "*"
#         },
#         "nsg-rule-02" ={      
#               name                        = "Inbound_Test"
#               priority                    = "100"
#               direction                   = "Inbound"
#               access                      = "Allow"
#               protocol                    = "Tcp"
#               source_port_range           = "*"
#               destination_port_range      = "*"
#               source_address_prefix       = "*"
#               destination_address_prefix  = "*"
#         }
# } 
depends_on = [module.vm-jumpbox-01]
}

module "nsg-nic-associate" {
  source = "./modules/nsg-nic"

network_interface_id      = module.vm-jumpbox-01.nic_id
network_security_group_id = module.nsg.nsg_id

depends_on = [module.vm-jumpbox-01]
}

**/

