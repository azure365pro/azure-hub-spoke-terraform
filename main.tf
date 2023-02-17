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

module "spoke1-resourcegroup" {
source = "./modules/resourcegroups"
# Resource Group Variables
az_rg_name     = "az-netb-pr-eastus2-rg"
az_rg_location = "eastus2"
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

module "mgmt-resourcegroup" {
source = "./modules/resourcegroups"
# Resource Group Variables
az_rg_name     = "az-mgmt-pr-eastus2-bkp-rg"
az_rg_location = "eastus2"
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

module "hub-vnet" {
source = "./modules/vnet"

virtual_network_name              = "az-conn-pr-eastus2-vnet"
resource_group_name               = module.hub-resourcegroup.rg_name
location                          = module.hub-resourcegroup.rg_location
virtual_network_address_space     = ["10.50.0.0/16"]
subnet_names = {
    "GatewaySubnet" = {
        subnet_name = "GatewaySubnet"
        address_prefixes = ["10.50.1.0/24"]
        route_table_name = ""
    },
    "AzureFirewallSubnet" = {
        subnet_name = "AzureFirewallSubnet"
        address_prefixes = ["10.50.2.0/24"]
        route_table_name = ""
    },
    "ApplicationGatewaySubnet" = {
        subnet_name = "ApplicationGatewaySubnet"
        address_prefixes = ["10.50.3.0/24"]
        route_table_name = ""
       }
    }
}

module "spoke1-vnet" {
source = "./modules/vnet"

virtual_network_name              = "az-netb-pr-eastus2-vnet"
resource_group_name               = module.spoke1-resourcegroup.rg_name
location                          = module.spoke1-resourcegroup.rg_location
virtual_network_address_space     = ["10.51.0.0/16"]
subnet_names = {
    "az-netb-pr-web-snet" = {
        subnet_name = "az-netb-pr-web-snet"
        address_prefixes = ["10.51.1.0/24"]
        route_table_name = ""
    },
    "az-netb-pr-db-snet" = {
        subnet_name = "az-netb-pr-db-snet"
        address_prefixes = ["10.51.2.0/24"]
        route_table_name = ""
    }
    }
}

module "hub-to-spoke1" {
source = "./modules/vnet-peering"
depends_on = [module.hub-vnet , module.spoke1-vnet , module.application_gateway, module.vpn_gateway , module.azure_firewall_01]

virtual_network_peering_name = "az-conn-pr-eastus2-vnet-to-az-netb-pr-eastus2-vnet"
resource_group_name          = module.hub-resourcegroup.rg_name
virtual_network_name         = module.hub-vnet.vnet_name
remote_virtual_network_id    = module.spoke1-vnet.vnet_id
allow_virtual_network_access = "true"
allow_forwarded_traffic      = "true"
allow_gateway_transit        = "true"
use_remote_gateways          = "false"

}

module "spoke1-to-hub" {
source = "./modules/vnet-peering"

virtual_network_peering_name = "az-netb-pr-eastus2-vnet-to-az-conn-pr-eastus2-vnet"
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


module "route_tables" {
source = "./modules/routetables"
depends_on = [module.hub-vnet , module.spoke1-vnet]

route_table_name              = "az-netb-pr-eastus2-route"
location                      = module.hub-resourcegroup.rg_location
resource_group_name           = module.hub-resourcegroup.rg_name
disable_bgp_route_propagation = false

route_name                    = "ToAzureFirewall"
address_prefix                = "0.0.0.0/0"
next_hop_type                 = "VirtualAppliance"
next_hop_in_ip_address        = module.azure_firewall_01.azure_firewall_private_ip

subnet_id_01                  = module.spoke1-vnet.vnet_subnet_id[0]
subnet_id_02                  = module.spoke1-vnet.vnet_subnet_id[1]


}



module "public_ip_01" {
source = "./modules/publicip"

public_ip_name      = "az-conn-pr-eastus2-vgw-pip01"
resource_group_name = module.hub-resourcegroup.rg_name
location            = module.hub-resourcegroup.rg_location
allocation_method   = "Static"
sku                 = "Standard"
}

module "public_ip_02" {
source = "./modules/publicip"

public_ip_name      = "az-conn-pr-eastus2-agw-pip02"
resource_group_name = module.hub-resourcegroup.rg_name
location            = module.hub-resourcegroup.rg_location
allocation_method   = "Static"
sku                 = "Standard"
}

module "public_ip_03" {
source = "./modules/publicip"

public_ip_name      = "az-conn-pr-eastus2-afw-pip03"
resource_group_name = module.hub-resourcegroup.rg_name
location            = module.hub-resourcegroup.rg_location
allocation_method   = "Static"
sku                 = "Standard"
}

module "azure_firewall_01" {
source = "./modules/azurefirewall"
depends_on = [module.hub-vnet]

  azure_firewall_name = "az-conn-pr-eastus2-afw"
  location            = module.hub-resourcegroup.rg_location
  resource_group_name = module.hub-resourcegroup.rg_name
  sku_name            = "AZFW_VNet"
  sku_tier            = "Standard"

  ipconfig_name        = "configuration"
  subnet_id            = module.hub-vnet.vnet_subnet_id[1]
  public_ip_address_id = module.public_ip_03.public_ip_address_id

  azure_firewall_policy_name            = "az-conn-pr-eastus2-afw-pol01"
 
# Firewall Policy Rules

  azure_firewall_policy_coll_group_name  = "az-conn-pr-eastus2-afw-coll-pol01" 
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
        }
    ]  


 application_rule_coll_name     = "blocked_websites"
 application_rule_coll_priority = "500"
 application_rule_coll_action   = "Deny"
 application_rules = [   
        {    
            name                  = "block_website_01"
            source_addresses      = ["*"]
            destination_fqdns     = ["bing.co.uk"]
        },
        {    
            name                  = "block_website_02"
            source_addresses      = ["*"]
            destination_fqdns     = ["bing.com"]
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

module "key_vault" {
source = "./modules/keyvault"

resource_group_name          = module.hub-resourcegroup.rg_name
location                     = module.hub-resourcegroup.rg_location

key_vault_name = "az-conn-pr-eastus2-kv"
sku_name = "standard"
admin_certificate_permissions = [
      "Create",
      "Delete",
      "DeleteIssuers",
      "Get",
      "GetIssuers",
      "Import",
      "List",
      "ListIssuers",
      "ManageContacts",
      "ManageIssuers",
      "Purge",
      "SetIssuers",
      "Update"
    ]

admin_key_permissions = [
      "Backup",
      "Create",
      "Decrypt",
      "Delete",
      "Encrypt",
      "Get",
      "Import",
      "List",
      "Purge",
      "Recover",
      "Restore",
      "Sign",
      "UnwrapKey",
      "Update",
      "Verify",
      "WrapKey"
    ]

admin_secret_permissions = [
      "Backup",
      "Delete",
      "Get",
      "List",
      "Purge",
      "Restore",
      "Restore",
      "Set"
    ] 

managed_identity_name               = "mi-appgw-keyvault"
managed_identity_secret_permissions = [
      "Get"
    ] 
}

module "application_gateway" {
source = "./modules/applicationgateway"

application_gateway_name       = "az-conn-pr-eastus2-agw"
resource_group_name            = module.hub-resourcegroup.rg_name
location                       = module.hub-resourcegroup.rg_location
key_vault_name                 = "az-conn-pr-eastus2-kv"
managed_identity_name          = "mi-appgw-keyvault"
public_ip_address_id           = module.public_ip_02.public_ip_address_id
subnet_id                      = module.hub-vnet.vnet_subnet_id[0]
cert_name                      = "prod"
 
sku_name                       = "Standard_v2"
tier                           = "Standard_v2"
capacity                       = 2

gateway_ip_configuration_name  = "gateway-ip-configuration-01"

frontend_port_name             = "myFrontendPort"
frontend_port_1                = "443"

backend_address_pool_name      = "myBackendPool"

frontend_ip_configuration_name = "myAGIPConfig"
http_setting_name              = "myHTTPsetting"
https_setting_name             = "myHTTPSsetting"
listener_name                  = "myListener"
request_routing_rule_name      = "myRoutingRule"
redirect_configuration_name    = "myRedirectConfig"
backend_ip_addresss            = ["10.51.1.4"]

probe_host_name                = "prod.virtualpetal.com"

}


module "vpn_gateway" {
source = "./modules/vpn-gateway"
depends_on = [module.hub-vnet , module.spoke1-vnet , module.azure_firewall_01 , module.application_gateway]

vpn_gateway_name              = "az-conn-pr-eastus2-01-vgw"
location                      = module.hub-resourcegroup.rg_location
resource_group_name           = module.hub-resourcegroup.rg_name

type                          = "ExpressRoute"
vpn_type                      = "PolicyBased"

sku                           = "Standard"
active_active                 = false
enable_bgp                    = false

ip_configuration              = "default"
private_ip_address_allocation = "Dynamic"
subnet_id                     = module.hub-vnet.vnet_subnet_id[2]
public_ip_address_id          = module.public_ip_01.public_ip_address_id

}


module "recovery_vault_01" {
source = "./modules/recoveryservicesvault"

recovery_vault_name = "az-mgmt-pr-eastus2-bkp"
resource_group_name = module.mgmt-resourcegroup.rg_name
location            = module.mgmt-resourcegroup.rg_location
sku                 = "Standard"
soft_delete_enabled = true
}

module "vm-windows-01" {
source = "./modules/vm-windows"
virtual_machine_name             = "aznetbrap01"
nic_name                         = "aznetbrap01-nic"
location                         = module.spoke1-resourcegroup.rg_location
resource_group_name              = module.spoke1-resourcegroup.rg_name
ipconfig_name                    = "ipconfig1"
subnet_id                        = module.spoke1-vnet.vnet_subnet_id[1]
private_ip_address_allocation    = "Static"
private_ip_address               = "10.51.1.4"
vm_size                          = "Standard_D8s_v3"
# Uncomment this line to delete the OS disk automatically when deleting the VM
delete_os_disk_on_termination    = true
# Uncomment this line to delete the data disks automatically when deleting the VM
delete_data_disks_on_termination = true

publisher                        = "MicrosoftWindowsServer"
offer                            = "WindowsServer"
sku                              = "2019-Datacenter"
storage_version                  = "latest"

os_disk_name                     = "aznetbrap01osdisk"
caching                          = "ReadWrite"
create_option                    = "FromImage"
managed_disk_type                = "Premium_LRS"

admin_username                   = "netb.admin"
admin_password                   = "Password1234!"

provision_vm_agent               = true
depends_on = [module.spoke1-vnet]
}

module "vm-linux-01" {
source = "./modules/vm-linux"
nic_name                         = "aznetbrdb01-nic"
location                         = module.spoke1-resourcegroup.rg_location
resource_group_name              = module.spoke1-resourcegroup.rg_name
ipconfig_name                    = "ipconfig1"
subnet_id                        = module.spoke1-vnet.vnet_subnet_id[0]
private_ip_address_allocation    = "Dynamic"
private_ip_address               = ""
# if you wish to have static - Change Dynamic to Static - Fill in Private IP
virtual_machine_name             = "aznetbrdb01"
vm_size                          = "Standard_D2s_v3"
# size                           = "Standard_D8s_v3"

publisher                        = "RedHat"
offer                            = "RHEL"
sku                              = "86-gen2"
storage_version                  = "latest"

os_disk_name                     = "aznetbrdb01osdisk"
caching                          = "ReadWrite"
managed_disk_type                = "Premium_LRS"
disk_size_gb                     = "511"

admin_username                   = "netb.admin"
admin_password                   = "Password1234!"
disable_password_authentication  = false
depends_on = [module.spoke1-vnet]
}

