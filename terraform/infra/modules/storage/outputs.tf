output "storage_account_name" {
  description = "The name of the application storage account"
  value       = azurerm_storage_account.app_storage.name
}

output "storage_account_primary_connection_string" {
  description = "The primary connection string for the storage account"
  value       = azurerm_storage_account.app_storage.primary_connection_string
  sensitive   = true
}

output "photos_container_name" {
  description = "The name of the Blob Container for profile photos"
  value       = azurerm_storage_container.photos.name
}

output "storage_account_id" {
  description = "The ID of the application storage account"
  value       = azurerm_storage_account.app_storage.id
}
