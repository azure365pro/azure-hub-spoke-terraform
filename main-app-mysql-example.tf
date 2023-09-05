/**
# Resource Group Module is Used to Create Resource Groups
module "linux-app-resourcegroup" {
source = "./modules/resourcegroups"
# Resource Group Variables
az_rg_name     = "az-365pro-pr-eastus-app-rg"
az_rg_location = "eastus"
az_tags = {
ApplicationName = "Linux with MySQL"
Role 		        = "Web and DB"
Owner 		      = "IT"
Environment	    = "Prod"
CompanyName     = "Azure365pro"
Criticality     = "Medium"
DR 		          = "No"
  }
}


module "jmp-box-resourcegroup" {
source = "./modules/resourcegroups"
# Resource Group Variables
az_rg_name     = "az-365pro-pr-eastus-jmp-rg"
az_rg_location = "eastus"
az_tags = {
ApplicationName = "Jump Box"
Role 		        = "For Admins"
Owner 		      = "IT"
Environment	    = "Prod"
CompanyName     = "Azure365pro"
Criticality     = "Medium"
DR 		          = "No"
  }
}

# vnet Module is used to create Virtual Networks and Subnets
module "app-vnet" {
source = "./modules/vnet"

virtual_network_name              = "az-365pro-pr-eastus-vnet"
resource_group_name               = module.linux-app-resourcegroup.rg_name
location                          = module.linux-app-resourcegroup.rg_location
virtual_network_address_space     = ["10.51.0.0/16"]

# Subnets are used in Index for other modules to refer
# module.app-vnet.vnet_subnet_id[0] = az-365pro-pr-db-snet      - Alphabetical Order
# module.app-vnet.vnet_subnet_id[1] = az-365pro-pr-jmp-snet     - Alphabetical Order
# module.app-vnet.vnet_subnet_id[2] = az-365pro-pr-web-snet     - Alphabetical Order

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
        snet_delegation  = "mysql"
    }
    "az-365pro-pr-jmp-snet" = {
        subnet_name = "az-365pro-pr-jmp-snet"
        address_prefixes = ["10.51.3.0/24"]
        route_table_name = ""
        snet_delegation  = ""
    }
    }
}


module "dns-zone" {
source = "./modules/dns-zone"

resource_group_name               = module.linux-app-resourcegroup.rg_name
private_dns_zone_name             = "appsvc-privatelink.mysql.database.azure.com"

}

module "vnet-dns-zone-link" {
source = "./modules/vnet-dns-zone-link"

resource_group_name               = module.linux-app-resourcegroup.rg_name
vnet_dns_zone_link_name           = "appsvc-privatelink.mysql.database.azure.com-vnetlink"
private_dns_zone_name             = module.dns-zone.dns_zone_name
virtual_network_id                = module.app-vnet.vnet_id
registration_enabled              = "true"

depends_on = [module.app-vnet, module.dns-zone]
}


module "mysql_server" {
source = "./modules/mysql"

  mysql_server_name                       = "az-365pro-pr-dbserver"
  database_subnet_id                      = module.app-vnet.vnet_subnet_id[0]
  private_dns_zone_id                     = module.dns-zone.dns_zone_id
  location                                = module.linux-app-resourcegroup.rg_location
  resource_group_name                     = module.linux-app-resourcegroup.rg_name
  mysql_db_sql_sku                        = "GP_Standard_D2ds_v4"
  mysql_db_database_version               = "8.0.21"
  mysql_db_database_georedundant_backup   = "false"
  mysql_server_username                   = "mysqladmin"
  mysql_server_password                   = "Password1234!"

  mysql_db_storage_size_gb                = "128"
  mysql_db_storage_iops                   = "700"

  mysql_databases = {
    "testdb1" = {
  mysql_database_name                     = "testdb1"
  charset                                 = "utf8mb3"
  collation                               = "utf8mb3_general_ci"  
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

depends_on = [module.app-vnet, module.dns-zone, module.vnet-dns-zone-link]
}

module "app-service-plan" {
source = "./modules/appservice"

resource_group_name               = module.linux-app-resourcegroup.rg_name
location                          = module.linux-app-resourcegroup.rg_location
app_service_hosting_plan_name     = "az-365pro-appsvc-plan"
app_service_hosting_plan_sku      = "P1v2"
os_type                           = "Linux"

depends_on = [module.app-vnet, module.mysql_server]

}
# Visual Studio: Ctrl+K, Ctrl+C to comment; Ctrl+K, Ctrl+U to uncomment.
# module "app-service-dev" {
# source = "./modules/appservice-linux"

# resource_group_name               = module.linux-app-resourcegroup.rg_name
# location                          = module.linux-app-resourcegroup.rg_location
# service_plan_id                   = module.app-service-plan.service_plan_id
# subnet_id                         = module.app-vnet.vnet_subnet_id[2]
# web_app_name                      = "az-365pro-dev"
# php_version                       = "8.0"

# depends_on = [module.app-vnet, module.mysql_server , module.app-service-plan]

# }


# module "app-service-uat" {
# source = "./modules/appservice-linux"

# resource_group_name               = module.linux-app-resourcegroup.rg_name
# location                          = module.linux-app-resourcegroup.rg_location
# service_plan_id                   = module.app-service-plan.service_plan_id
# subnet_id                         = module.app-vnet.vnet_subnet_id[2]
# web_app_name                      = "az-365pro-uat"
# php_version                       = "8.0"

# depends_on = [module.app-vnet, module.mysql_server , module.app-service-plan]

# }


module "app-service-prod" {
source = "./modules/appservice-linux"

resource_group_name               = module.linux-app-resourcegroup.rg_name
location                          = module.linux-app-resourcegroup.rg_location
service_plan_id                   = module.app-service-plan.service_plan_id
subnet_id                         = module.app-vnet.vnet_subnet_id[2]
web_app_name                      = "az-365pro-prod"
runtime                           = "php"
php_version                       = "8.0"

depends_on = [module.app-vnet, module.mysql_server , module.app-service-plan]

}


# publicip Module is used to create Public IP Address
module "public_ip_01" {
source = "./modules/publicip"

# Used for Jump Box
public_ip_name      = "az-jmp-pr-eastus-pip01"
resource_group_name = module.jmp-box-resourcegroup.rg_name
location            = module.jmp-box-resourcegroup.rg_location
allocation_method   = "Static"
sku                 = "Standard"
}


module "vm-jumpbox-01" {
source = "./modules/vm-windows"
virtual_machine_name             = "azjump01"
nic_name                         = "azjump01-nic"
location                         = module.jmp-box-resourcegroup.rg_location
resource_group_name              = module.jmp-box-resourcegroup.rg_name
ipconfig_name                    = "ipconfig1"
subnet_id                        = module.app-vnet.vnet_subnet_id[1]
private_ip_address_allocation    = "Dynamic"
private_ip_address               = ""
vm_size                          = "Standard_D2s_v3"
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
admin_password                   = "Password1234!"

provision_vm_agent               = true

public_ip_address_id             = module.public_ip_01.public_ip_address_id

depends_on = [module.app-vnet , module.public_ip_01 ]
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


