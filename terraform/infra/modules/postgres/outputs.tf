output "server_fqdn" {
  description = "The fully qualified domain name of the PostgreSQL server"
  value       = azurerm_postgresql_flexible_server.main.fqdn
}

output "database_name" {
  description = "The name of the database"
  value       = azurerm_postgresql_flexible_server_database.main.name
}

output "admin_username" {
  description = "The administrator username"
  value       = azurerm_postgresql_flexible_server.main.administrator_login
}

output "connection_string" {
  description = "The Prisma connection string format"
  value       = "postgresql://${azurerm_postgresql_flexible_server.main.administrator_login}:${var.db_password}@${azurerm_postgresql_flexible_server.main.fqdn}:5432/${azurerm_postgresql_flexible_server_database.main.name}?sslmode=require"
  sensitive   = true
}
