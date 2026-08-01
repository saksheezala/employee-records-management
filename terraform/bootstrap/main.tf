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