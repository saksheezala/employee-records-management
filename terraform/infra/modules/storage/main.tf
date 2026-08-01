
resource "azurerm_storage_account" "app_storage" {
  name                     = "${var.prefix}app"
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS" # Locally Redundant Storage for cost optimization
  min_tls_version          = "TLS1_2"

  # Security best practice
  allow_nested_items_to_be_public = false

  tags = {
    environment = "production"
  }
}

# The specific container to hold employee profile photos
resource "azurerm_storage_container" "photos" {
  name                 = "profile-photos"
  storage_account_name = azurerm_storage_account.app_storage.name

  # Set to private. The backend will generate Shared Access Signature (SAS) tokens
  # so that users can download their photos securely.
  container_access_type = "private"
}
