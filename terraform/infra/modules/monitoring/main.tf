resource "azurerm_log_analytics_workspace" "main" {
  name                = "${var.prefix}-law"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018" # Standard pay-as-you-go SKU, cost optimized
  retention_in_days   = 30          # Lowest retention allowed for free ingestion tiers

  tags = {
    environment = "production"
  }
}

resource "azurerm_application_insights" "main" {
  name                = "${var.prefix}-appinsights"
  location            = var.location
  resource_group_name = var.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = "web"

  tags = {
    environment = "production"
  }
}
