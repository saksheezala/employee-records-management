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

provider "azurerm" {
  features {}

  # When running in CI/CD, authenticate via ARM_* environment variables (Service Principal).
  # This prevents Terraform from attempting to fall back to the Azure CLI session,
  # which only supports User accounts, not Service Principals.
  use_cli = false
}
