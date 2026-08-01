output "resource_group_name" {
  description = "The name of the Resource Group containing the Terraform state"
  value       = azurerm_resource_group.tfstate.name
}

output "storage_account_name" {
  description = "The name of the Storage Account containing the Terraform state"
  value       = azurerm_storage_account.tfstate.name
}

output "container_name" {
  description = "The name of the Blob Container containing the Terraform state"
  value       = azurerm_storage_container.tfstate.name
}

output "backend_config" {
  description = "Snippet for configuring the remote backend in terraform/infra/backend.tf"
  value       = <<EOT
terraform {
  backend "azurerm" {
    resource_group_name  = "${azurerm_resource_group.tfstate.name}"
    storage_account_name = "${azurerm_storage_account.tfstate.name}"
    container_name       = "${azurerm_storage_container.tfstate.name}"
    key                  = "prod.terraform.tfstate"
  }
}
EOT
}
