output "default_hostname" {
  description = "The default URL of the frontend UI"
  value       = azurerm_linux_web_app.main.default_hostname
}

output "principal_id" {
  description = "The Principal ID of the App Service's Managed Identity"
  value       = azurerm_linux_web_app.main.identity[0].principal_id
}
