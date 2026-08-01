resource "azurerm_container_registry" "main" {
  name                = "${var.prefix}acr"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Basic"
  admin_enabled       = false # Security best practice: Disable admin user, rely on Managed Identity

  tags = {
    environment = "production"
  }
}
