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
# Credentials are passed via TF_VAR_* environment variables in CI/CD.
# This guarantees Terraform never falls back to Azure CLI session auth,
# which is unsupported for Service Principals.
provider "azurerm" {
  features {}

  use_cli         = false
  subscription_id = var.arm_subscription_id
  tenant_id       = var.arm_tenant_id
  client_id       = var.arm_client_id
  client_secret   = var.arm_client_secret
}
