# Azure Hub and Spoke Network using reusable Terraform modules - Azure365Pro.com 
Blog Reference - https://www.azure365pro.com/azure-hub-and-spoke-network-using-reusable-terraform-modules/

# Introduction 
Deployment for  Infrastructure with Hub and Spoke model. Its compliant with Cloud Adoption Framework.

We will be deploying the below resources using Terraform reusable modules.

✅ Virtual Networks (Hub - 10.50.0.0/16 - Spoke - 10.51.0.0/16)<br />
✅ VPN Gateway (10.50.1.0/24)  - Not Provisioned by Default<br />
✅ Azure Firewall (10.50.2.0/24)<br />
✅ Application Gateway (10.50.3.0/24) - Not Provisioned by Default<br />
✅ Azure Bastion (10.50.4.0/24)<br />
✅ Jump Box (Windows 11) (10.50.5.0/24)<br />
✅ Windows Server 2019 Web Server (10.51.1.0/24)<br />
✅ Linux RHEL Server (10.51.2.0/24)<br />
✅ Public IP Addresses<br />
✅ Recovery Services Vault<br />
✅ Azure Key Vault - Not Provisioned by Default<br />
✅ Route Tables<br />
✅ Azure Firewall Policies<br />

Modules are convenient to place into folders and reuse resource configurations with Terraform for multiple deployments.
Also, changing / upgrading specific resource configurations becomes easier

![alt text](https://www.azure365pro.com/wp-content/uploads/2023/02/Azure-Hub-and-Spoke-v1-scaled.jpg)

# Getting Started

1. Terraform latest version is installed

![alt text](https://www.azure365pro.com/wp-content/uploads/2023/02/image-21.png)

2. Az cli is installed / az login is completed (az login)

![alt text](https://www.azure365pro.com/wp-content/uploads/2023/02/image-22.png)

3. git is installed to clone repo (git clone)

![alt text](https://www.azure365pro.com/wp-content/uploads/2023/02/image-7.png)

# Deploy using Terraform 

terraform init<br />
Initialize prepares the working directory so Terraform can run the configuration.

![alt text](https://www.azure365pro.com/wp-content/uploads/2023/02/image-10.png)

terraform plan<br />
lets you preview any changes before you apply them

![alt text](https://www.azure365pro.com/wp-content/uploads/2023/02/image-12.png)

terraform apply<br />
Executes the changes defined by your Terraform configuration to create, update, or destroy resources.

![alt text](https://www.azure365pro.com/wp-content/uploads/2023/02/image-13.png)

