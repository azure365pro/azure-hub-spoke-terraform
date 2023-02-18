# Introduction 
Deployment for  Infrastructure with Hub and Spoke model. Its compliant with Cloud Adoption Framework.

# Getting Started

terraform init
terraform plan 
terraform apply

# Resource Provisioned 

1.  Virtual Networks (Hub - 10.51.0.0/16  / Spoke - 10.50.0.0/16)
2.  Virtual Network Gateway (10.50.1.0/24)
3.  Azure Firewall (10.50.2.0/24)
4.  Application Gateway (10.50.3.0/24) - Not Provisioned by Default
5.  Azure Bastion (10.50.4.0/24)
6.  Jump Box (Windows 11) (10.50.4.0/24)
7.  Windows Server 2019 Web Server with 256 GB Hard Disk (10.51.1.0/24) 
8.  Linux RHEL Server with 512 GB Hard Disk (10.51.2.0/24) 
9.  Public IP Addresses
10. Recovery Services Vault
11. Azure Key Vault - Not Provisioned by Default

