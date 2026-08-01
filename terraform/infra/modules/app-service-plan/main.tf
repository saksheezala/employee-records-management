resource "azurerm_service_plan" "main" {
  name                = "${var.prefix}-asp"
  location            = var.location
  resource_group_name = var.resource_group_name

  # Must be Linux to run Docker Containers
  os_type = "Linux" 

  # Cost Optimization: B1 (Basic 1) is a low-cost compute tier 
  # that supports custom domains and manual scaling.
  sku_name = "B1"

  tags = {
    environment = "production"
  }
}
