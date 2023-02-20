# azure-hub-spoke-terraform - Azure365Pro.com 

# Introduction 
Deployment for  Infrastructure with Hub and Spoke model. Its compliant with Cloud Adoption Framework.

We will be deploying the below resources using Terraform reusable modules.

1 Virtual Networks (Hub – 10.51.0.0/16 / Spoke – 10.50.0.0/16)
2 Azure Firewall (10.50.2.0/24)
3 Azure Bastion (10.50.4.0/24)
4 Jump Box (Windows 11) (10.50.4.0/24)
5 Windows Server 2019 Web Server with 256 GB Hard Disk (10.51.1.0/24)
6 Linux RHEL Server with 512 GB Hard Disk (10.51.2.0/24)
7 Public IP Addresses
8 Recovery Services Vault
9 Virtual Network Gateway (10.50.1.0/24) – Not Provisioned by Default
10 Azure Key Vault – Not Provisioned by Default
11 Application Gateway (10.50.3.0/24) – Not Provisioned by Default
12 Route Tables – Routing Traffic to Azure Firewall from Spoke

Modules are convenient to place into folders and reuse resource configurations with Terraform for multiple deployments.
Also, changing / upgrading specific resource configurations becomes easier


# Getting Started

Terraform latest version is installed
Az cli is installed / az login is completed (az login)
git is installed to clone repo (git clone "https://github.com/azure365pro/azure-hub-spoke-terraform")

terraform init

![alt text](https://www.azure365pro.com/wp-content/uploads/2023/02/image-10.png)

terraform plan 

![alt text](https://www.azure365pro.com/wp-content/uploads/2023/02/image-12.png)

terraform apply

![alt text](https://www.azure365pro.com/wp-content/uploads/2023/02/image-13.png)


# Resource Provisioned 

1.  Virtual Networks (Hub - 10.51.0.0/16  / Spoke - 10.50.0.0/16)
2.  Virtual Network Gateway (10.50.1.0/24) - Not Provisioned by Default
3.  Azure Firewall (10.50.2.0/24)
4.  Application Gateway (10.50.3.0/24) - Not Provisioned by Default
5.  Azure Bastion (10.50.4.0/24)
6.  Jump Box (Windows 11) (10.50.4.0/24)
7.  Windows Server 2019 Web Server with 256 GB Hard Disk (10.51.1.0/24) 
8.  Linux RHEL Server with 512 GB Hard Disk (10.51.2.0/24) 
9.  Public IP Addresses
10. Recovery Services Vault
11. Azure Key Vault - Not Provisioned by Default

