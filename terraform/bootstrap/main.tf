variable "location" {
  description = "The Azure region to deploy resources into"
  type        = string
  default     = "centralindia"
}

variable "prefix" {
  description = "Prefix for all resources to ensure unique names"
  type        = string
  default     = "erboot"
}

variable "cicd_principal_object_id" {
  description = "Object ID of the Azure DevOps Service Principal that runs the CI/CD pipeline."
  type        = string
  default     = "3e5a73d9-0467-409d-90a0-332e81ab7346"
}

variable "prod_resource_group_id" {
  description = "Resource ID of the production resource group (erprod-rg). The CI/CD service principal is granted User Access Administrator here so it can manage role assignments during terraform apply."
  type        = string
  default     = "/subscriptions/dd4acb4c-17ed-4972-8c07-22672fe441b6/resourceGroups/erprod-rg"
}

resource "azurerm_resource_group" "tfstate" {
  name     = "${var.prefix}-tfstate-rg"
  location = var.location
}

resource "azurerm_storage_account" "tfstate" {
  name                     = "${var.prefix}tfstate"
  resource_group_name      = azurerm_resource_group.tfstate.name
  location                 = azurerm_resource_group.tfstate.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Locally Redundant Storage is sufficient for bootstrap/learning
  min_tls_version          = "TLS1_2"

  # Best practice: Do not allow public anonymous access to the storage account itself
  allow_nested_items_to_be_public = false

  tags = {
    environment = "bootstrap"
    purpose     = "terraform-state"
  }
}

resource "azurerm_storage_container" "tfstate" {
  name                  = "tfstate"
  storage_account_name  = azurerm_storage_account.tfstate.name
  container_access_type = "private"
}

# Grant the Azure DevOps Service Principal permission to read/write
# Terraform state in this storage account. Required for 'terraform init'
# to connect to the azurerm backend from the CI/CD pipeline.
resource "azurerm_role_assignment" "cicd_sp_tfstate_access" {
  scope                = azurerm_storage_account.tfstate.id
  role_definition_name = "Storage Account Contributor"
  principal_id         = var.cicd_principal_object_id
}

# Grant the Azure DevOps Service Principal 'User Access Administrator' on the
# production resource group. This allows the pipeline to create and delete
# role assignments (e.g. Key Vault RBAC, ACR pull, Storage blob contributor)
# during 'terraform apply'. The service principal's Contributor role alone
# does NOT include Microsoft.Authorization/roleAssignments/write or /delete.
resource "azurerm_role_assignment" "cicd_sp_prod_rg_uaa" {
  scope                = var.prod_resource_group_id
  role_definition_name = "User Access Administrator"
  principal_id         = var.cicd_principal_object_id
}