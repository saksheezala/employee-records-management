output "resource_group_name" {
  description = "The name of the main production resource group"
  value       = module.resource_group.name
}

output "app_insights_instrumentation_key" {
  description = "App Insights Instrumentation Key"
  value       = module.monitoring.app_insights_instrumentation_key
  sensitive   = true
}

output "app_insights_connection_string" {
  description = "App Insights Connection String"
  value       = module.monitoring.app_insights_connection_string
  sensitive   = true
}

output "key_vault_uri" {
  description = "The URI of the Key Vault"
  value       = module.key_vault.key_vault_uri
}

output "storage_account_name" {
  description = "The name of the application storage account"
  value       = module.storage.storage_account_name
}

output "photos_container_name" {
  description = "The name of the Blob Container for profile photos"
  value       = module.storage.photos_container_name
}

output "database_fqdn" {
  description = "The fully qualified domain name of the PostgreSQL server"
  value       = module.postgres.server_fqdn
}

output "database_connection_string" {
  description = "The Prisma connection string for the backend app"
  value       = module.postgres.connection_string
  sensitive   = true
}

output "app_service_plan_id" {
  description = "The ID of the App Service Plan"
  value       = module.app_service_plan.plan_id
}

output "backend_url" {
  description = "The URL of the Backend API"
  value       = "https://${module.backend_app.default_hostname}"
}

output "frontend_url" {
  description = "The URL of the Frontend UI"
  value       = "https://${module.frontend_app.default_hostname}"
}

output "acr_login_server" {
  description = "The Login Server URL of the Azure Container Registry"
  value       = module.acr.acr_login_server
}
