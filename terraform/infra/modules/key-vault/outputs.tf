output "key_vault_id" {
  description = "The ID of the Key Vault"
  value       = azurerm_key_vault.main.id
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = azurerm_key_vault.main.vault_uri
}

output "db_password" {
  description = "The generated database password"
  value       = azurerm_key_vault_secret.db_password.value
  sensitive   = true
}

output "jwt_secret" {
  description = "The generated JWT secret"
  value       = azurerm_key_vault_secret.jwt_secret.value
  sensitive   = true
}
