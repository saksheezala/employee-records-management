

resource "azurerm_key_vault" "main" {
  name                        = "${var.prefix}-kv"
  location                    = var.location
  resource_group_name         = var.resource_group_name
  enabled_for_disk_encryption = true
  tenant_id                   = var.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false # Set to false for easier teardown during development
  sku_name                    = "standard"

  # Access policy for the user executing Terraform
  access_policy {
    tenant_id = var.tenant_id
    object_id = var.object_id

    secret_permissions = [
      "Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"
    ]
  }

  lifecycle {
    ignore_changes = [
      access_policy
    ]
  }
}

# Generate a strong random password for the PostgreSQL database
resource "random_password" "db_password" {
  length           = 16
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

# Generate a strong random secret for JWT signing
resource "random_password" "jwt_secret" {
  length  = 64
  special = false
}

# Store the DB password in Key Vault
resource "azurerm_key_vault_secret" "db_password" {
  name         = "DatabasePassword"
  value        = random_password.db_password.result
  key_vault_id = azurerm_key_vault.main.id
}

# Store the JWT secret in Key Vault
resource "azurerm_key_vault_secret" "jwt_secret" {
  name         = "JwtSecret"
  value        = random_password.jwt_secret.result
  key_vault_id = azurerm_key_vault.main.id
}
