/**
#Comment the Other Main.tf and uncomment this file by removing the first and last line 
# and run it to provision the Azure HDinsights kafka cluster

# Resource Group Module is Used to Create Resource Groups
module "hub-resourcegroup" {
source = "./modules/resourcegroups"
# Resource Group Variables
az_rg_name      = "az-conn-pr-eastus2-net-rg"
az_rg_location  = "eastus2"
az_tags = {
ApplicationName = "Network"
Role 		    = "Network"
Owner 		    = "IT"
Environment	    = "Prod"
CompanyName     = "NETB"
Criticality     = "Medium"
DR 		        = "No"
  }
}

# Resource Group Module is Used to Create Resource Groups
module "spoke1-resourcegroup" {
source = "./modules/resourcegroups"
# Resource Group Variables
az_rg_name     = "az-netb-pr-eastus2-rg"
az_rg_location = "eastus2"
az_tags = {
ApplicationName = "kafka"
Role 		    = "IT"
Owner 		    = "IT"
Environment	    = "Prod"
CompanyName     = "EUG"
Criticality     = "Medium"
DR 		        = "No"
  }
}


# vnet Module is used to create Virtual Networks and Subnets
module "hub-vnet" {
source = "./modules/vnet"

virtual_network_name              = "az-conn-pr-eastus2-vnet"
resource_group_name               = module.hub-resourcegroup.rg_name
location                          = module.hub-resourcegroup.rg_location
virtual_network_address_space     = ["10.50.0.0/16"]
# Subnets are used in Index for other modules to refer
# module.hub-vnet.vnet_subnet_id[0] = GatewaySubnet  - Alphabetical Order

subnet_names = {
    "GatewaySubnet" = {
        subnet_name = "GatewaySubnet"
        address_prefixes = ["10.50.1.0/24"]
        route_table_name = ""
    }
    }
}

# vnet Module is used to create Virtual Networks and Subnets
module "spoke1-vnet" {
source = "./modules/vnet"

virtual_network_name              = "az-netb-pr-eastus2-vnet"
resource_group_name               = module.spoke1-resourcegroup.rg_name
location                          = module.spoke1-resourcegroup.rg_location
virtual_network_address_space     = ["10.51.0.0/16"]
subnet_names = {
    "az-netb-pr-kafka-h-snet" = {
        subnet_name = "az-netb-pr-kafka-h-snet"
        address_prefixes = ["10.51.1.0/24"]
        route_table_name = ""
    },
    "az-netb-pr-kafka-w-snet" = {
        subnet_name = "az-netb-pr-kafka-h-snet"
        address_prefixes = ["10.51.2.0/24"]
        route_table_name = ""
    }
    "az-netb-pr-kafka-z-snet" = {
        subnet_name = "az-netb-pr-kafka-h-snet"
        address_prefixes = ["10.51.3.0/24"]
        route_table_name = ""
    }
    }
}

# vnet-peering Module is used to create peering between Virtual Networks
module "hub-to-spoke1" {
source = "./modules/vnet-peering"
depends_on = [module.hub-vnet , module.spoke1-vnet]
#depends_on = [module.hub-vnet , module.spoke1-vnet , module.application_gateway, module.vpn_gateway , module.azure_firewall_01]

virtual_network_peering_name = "az-conn-pr-eastus2-vnet-to-az-netb-pr-eastus2-vnet"
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

virtual_network_peering_name = "az-netb-pr-eastus2-vnet-to-az-conn-pr-eastus2-vnet"
resource_group_name          = module.spoke1-resourcegroup.rg_name
virtual_network_name         = module.spoke1-vnet.vnet_name
remote_virtual_network_id    = module.hub-vnet.vnet_id
allow_virtual_network_access = "true"
allow_forwarded_traffic      = "true"
allow_gateway_transit        = "false"
# As there is no Express Route gateway or No Firewall while testing - Setting to False
# Otherwise 
# use_remote_gateways   = "true"
use_remote_gateways          = "false"
depends_on = [module.hub-vnet , module.spoke1-vnet]
}

# publicip Module is used to create Public IP Address
module "public_ip_01" {
source = "./modules/publicip"

# Used for VPN Gateway 
public_ip_name      = "az-conn-pr-eastus2-vgw-pip01"
resource_group_name = module.hub-resourcegroup.rg_name
location            = module.hub-resourcegroup.rg_location
allocation_method   = "Static"
sku                 = "Standard"
}

# vpn-gateway Module is used to create Express Route Gateway So that it can connect to the express route Circuit
# or to provide private access
module "vpn_gateway" {
source = "./modules/vpn-gateway"
depends_on = [module.hub-vnet , module.spoke1-vnet ]

vpn_gateway_name              = "az-conn-pr-eastus2-01-vgw"
location                      = module.hub-resourcegroup.rg_location
resource_group_name           = module.hub-resourcegroup.rg_name

type                          = "Vpn"
vpn_type                      = "RouteBased"

sku                           = "VpnGw2"
active_active                 = false
enable_bgp                    = false

ip_configuration              = "default"
private_ip_address_allocation = "Dynamic"
subnet_id                     = module.hub-vnet.vnet_subnet_id[0]
public_ip_address_id          = module.public_ip_01.public_ip_address_id

}

module "hdinsight_kafka" {
source = "./modules/hdinsight-kafka"
depends_on = [module.hub-vnet , module.spoke1-vnet ]

location                      = module.hub-resourcegroup.rg_location
resource_group_name           = module.hub-resourcegroup.rg_name

storage_account_name          = "hdinsightstor"
account_tier                  = "Standard"
account_replication_type      = "LRS"

storage_container_name        = "kafka"
container_access_type         = "private"

kafka_cluster_name            = "kakfa-us-cluster"

cluster_version               = "4.0"
tier                          = "Standard"
kafka_version                 = "2.4"

gw_username                   = "kakfausergw"
gw_password                   = "Terr!form123!"

nodes_username                = "kakfausernde"
nodes_password                = "Terr!form123!"
number_of_disks_per_node      = 3
target_instance_count         = 3

spoke1_vnet_id                = module.spoke1-vnet.vnet_id
# Head Nodes
h_subnet_id                   = module.spoke1-vnet.vnet_subnet_id[0]
h_vm_size                     = "Standard_D3_V2"
# Worker Nodes
w_subnet_id                   = module.spoke1-vnet.vnet_subnet_id[1]
w_vm_size                     = "Standard_D3_V2"
# Zookeeper Nodes 
z_subnet_id                   = module.spoke1-vnet.vnet_subnet_id[2]
z_vm_size                     = "Standard_D3_V2"

}

**/


