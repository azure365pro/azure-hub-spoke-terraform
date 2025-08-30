/**

terraform { 
  backend "azurerm" {} 
}

**/
provider "azurerm" {
  resource_provider_registrations = "none"
  subscription_id = "808c0b1c-e71d-4e23-8a94-033b4b3edced"
/*  
    tenant_id       = "xxxxx"
    client_id       = "xxxxx"
    client_secret   = "xxxxx" 
*/
  features {
        key_vault {
      purge_soft_delete_on_destroy    = true
      recover_soft_deleted_key_vaults = true
    }
  }


}
# if you dont want aws provider to be installed comment the below section

  provider "aws" {
  region = "us-east-1"
  }

