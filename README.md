# Azure Hub and Spoke Network using reusable Terraform modules - Azure365Pro.com 
Blog Reference for Azure Hub and Spoke   - https://www.azure365pro.com/azure-hub-and-spoke-network-using-reusable-terraform-modules/<br />
<br />
Blog Reference for Apache Kafka on HDInsight - https://www.azure365pro.com/deploy-apache-kafka-in-azure-hdinsight-using-reusable-terraform-modules/<br />
<br />
Support        - Support@Azure365Pro.com

# Introduction 
<p>We will deploy the resources below using Terraform reusable modules utilizing the Azure landing zone concept, part of the Cloud Adoption Framework (CAF). In this setup, we are talking about only infra resources; <a href="https://www.youtube.com/watch?v=1y4lstUzt_k&amp;t" target="_blank" rel="noreferrer noopener">if you are new to terraform</a>, the same concept has been <a href="https://www.youtube.com/watch?v=h5K4oGXAYeg" target="_blank" rel="noreferrer noopener">explained using the Azure Portal</a>; I have spoken about Azure Management Groups and Subscription Planning in this link - <a href="https://www.youtube.com/watch?v=T6YO1gKcjyU">Azure Management Groups and Subscriptions Design</a> </p>

<p>Azure landing zone design that accounts for scale, security governance, networking, and identity, which enables seamless application migration, modernization, and innovation at the enterprise scale in Azure. This approach considers all platform resources like infrastructure (Iaas) or platform as a service.<br><br>Benefits of Azure Landing Zones -</p>

<li>Good Governance</li>

Like you can place a policy in the overall environment that no internet-exposing storage accounts can be provisioned

<li>Security</li>

Improved Security controls, Network segmentation, Identity management, Service Principals, Managed Identities

<li>Scalability</li>

Multi Datacenter or Improving the design with Virtual WAN should be seamless

<li>Cost Savings</li>

Segregated billing with subscriptions - Overall Control or like can apply Hybrid benefit using policies

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
✅ Apache Kafka on HDInsight - Not Provisioned by Default<br />

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

Blog Reference for Azure Hub and Spoke   - https://www.azure365pro.com/azure-hub-and-spoke-network-using-reusable-terraform-modules/<br />
<br />
Blog Reference for Apache Kafka on HDInsight - https://www.azure365pro.com/deploy-apache-kafka-in-azure-hdinsight-using-reusable-terraform-modules/<br />
<br />
Support        - Support@Azure365Pro.com
