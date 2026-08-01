terraform {
  backend "azurerm" {
    resource_group_name  = "erboot-tfstate-rg"
    storage_account_name = "erboottfstate"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}
