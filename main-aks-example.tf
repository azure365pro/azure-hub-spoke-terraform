/**

# if you are running Against new Subscription 
# az provider register --namespace Microsoft.OperationalInsights
# az provider register --namespace Microsoft.OperationsManagement
# az provider register --namespace Microsoft.ContainerService
# az feature register --namespace "Microsoft.Compute" --name "EncryptionAtHost"

# 
# To Check status - Usually Takes time
# az feature show --namespace "Microsoft.Compute" --name "EncryptionAtHost" 
# 

# Resource Group Module is Used to Create Resource Groups
module "hub-resourcegroup" {
source = "./modules/resourcegroups"
# Resource Group Variables
az_rg_name      = "az-conn-pr-qar-net-rg"
az_rg_location  = "qatarcentral"
az_tags = {
ApplicationName = "Network"
Role 		    = "Network"
Owner 		    = "IT"
Environment	    = "Prod"
CompanyName     = "GIG"
Criticality     = "Medium"
DR 		        = "No"
  }
}

# Resource Group Module is Used to Create Resource Groups
module "spoke1-resourcegroup" {
source = "./modules/resourcegroups"
# Resource Group Variables
az_rg_name     = "az-gig-pr-qar-aks-rg"
az_rg_location = "qatarcentral"
az_tags = {
ApplicationName = "Network"
Role 		    = "Network"
Owner 		    = "IT"
Environment	    = "Prod"
CompanyName     = "GIG"
Criticality     = "Medium"
DR 		        = "No"
  }
}


# vnet Module is used to create Virtual Networks and Subnets
module "hub-vnet" {
source = "./modules/vnet"

virtual_network_name              = "az-conn-pr-qar-vnet"
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

virtual_network_name              = "az-gig-pr-qar-vnet"
resource_group_name               = module.spoke1-resourcegroup.rg_name
location                          = module.spoke1-resourcegroup.rg_location
virtual_network_address_space     = ["10.51.0.0/16"]
subnet_names = {
    "az-gig-pr-web-snet" = {
        subnet_name = "az-gig-pr-aks-snet"
        address_prefixes = ["10.51.0.0/21"]
        route_table_name = ""
        snet_delegation  = ""
    },
   }
}

# vnet-peering Module is used to create peering between Virtual Networks
module "hub-to-spoke1" {
source = "./modules/vnet-peering"
depends_on = [module.hub-vnet , module.spoke1-vnet , module.azure_firewall_01]
#depends_on = [module.hub-vnet , module.spoke1-vnet , module.application_gateway, module.vpn_gateway , module.azure_firewall_01]

virtual_network_peering_name = "az-conn-pr-qar-vnet-to-az-gig-pr-qar-vnet"
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

virtual_network_peering_name = "az-gig-pr-qar-vnet-to-az-conn-pr-qar-vnet"
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

route_table_name              = "az-gig-pr-qar-route"
location                      = module.hub-resourcegroup.rg_location
resource_group_name           = module.hub-resourcegroup.rg_name
disable_bgp_route_propagation = false

route_name                    = "ToAzureFirewall"
address_prefix                = "0.0.0.0/0"
next_hop_type                 = "VirtualAppliance"
next_hop_in_ip_address        = module.azure_firewall_01.azure_firewall_private_ip

  subnet_ids                    = [
    module.spoke1-vnet.vnet_subnet_id[0]
  ]


}


# publicip Module is used to create Public IP Address
module "public_ip_03" {
source = "./modules/publicip"

# Used for Azure Firewall 
public_ip_name      = "az-conn-pr-qar-afw-pip03"
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

  azure_firewall_name = "az-conn-pr-qar-afw"
  location            = module.hub-resourcegroup.rg_location
  resource_group_name = module.hub-resourcegroup.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ipconfig_name        = "configuration"
  subnet_id            = module.hub-vnet.vnet_subnet_id[0]
  public_ip_address_id = module.public_ip_03.public_ip_address_id

  azure_firewall_policy_coll_group_name  = "az-conn-pr-qar-afw-coll-pol01" 
  azure_firewall_policy_name             = "az-conn-pr-qar-afw-pol01"  
  priority                               = 100

  network_rule_coll_name_01     = "Blocked_Network_Rules"
  network_rule_coll_priority_01 = "1000"
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
  network_rule_coll_priority_02 = "2000"
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
            source_addresses      = ["10.51.0.0/21"]
            destination_addresses = ["*"]
            destination_ports     = ["*"]
            protocols             = ["TCP","UDP"]
        }
    ]  


 application_rule_coll_name     = "Allowed_websites"
 application_rule_coll_priority = "500"
 application_rule_coll_action   = "Allow"
 application_rules = [   
        {    
            name                  = "Allowed_website_01"
            source_addresses      = ["*"]
            destination_fqdns     = ["bing.co.uk"]
        },
        {    
            name                  = "Allowed_website_02"
            source_addresses      = ["*"]
            destination_fqdns     = ["*.bing.com"]
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
  prefix                            = "az-gig-pr-aks"
  cluster_name                      = "az-gig-pr-aks-cluster"
  vnet_subnet_id                    = module.spoke1-vnet.vnet_subnet_id[0]
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

  depends_on = [module.spoke1-vnet, module.azure_firewall_01]
}
**/
