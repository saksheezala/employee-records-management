resource "azurerm_postgresql_flexible_server" "main" {
  name                   = "${var.prefix}-pg"
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "15"
  administrator_login    = "eradmin"
  administrator_password = var.db_password # Pulled directly from Key Vault output!
  
  # Cost Optimization: Burstable B1ms is the cheapest tier (approx $14/month)
  sku_name   = "B_Standard_B1ms"
  storage_mb = 32768 # 32 GB is the minimum

  
  tags = {
    environment = "production"
  }

  # Azure assigns a default zone upon creation. 
  # We ignore it so Terraform doesn't try to remove it on subsequent applies.
  lifecycle {
    ignore_changes = [
      zone,
      high_availability.0.standby_availability_zone
    ]
  }
}

# The specific database inside the server
resource "azurerm_postgresql_flexible_server_database" "main" {
  name      = "employeedb"
  server_id = azurerm_postgresql_flexible_server.main.id
  charset   = "UTF8"
  collation = "en_US.utf8"
}

# Allow Azure Services to connect to this database
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure" {
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

# Allow your local machine to connect (for running Prisma migrations)
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name             = "AllowAllIPs"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}
