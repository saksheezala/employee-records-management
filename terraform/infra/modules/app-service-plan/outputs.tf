output "plan_id" {
  description = "The ID of the App Service Plan"
  value       = azurerm_service_plan.main.id
}
