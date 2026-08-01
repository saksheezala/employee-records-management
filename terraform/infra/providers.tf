terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.0"
    }
  }
}

# Explicit Service Principal authentication.
# Credentials are injected via ARM_* environment variables in CI/CD.
# use_cli = false ensures the provider never touches the Azure CLI session.
provider "azurerm" {
  features {}
  use_cli = false
}
