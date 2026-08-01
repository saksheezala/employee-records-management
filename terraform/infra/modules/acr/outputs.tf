output "acr_id" {
  description = "The ID of the Container Registry"
  value       = azurerm_container_registry.main.id
}

output "acr_login_server" {
  description = "The login server URL for the Container Registry"
  value       = azurerm_container_registry.main.login_server
}
