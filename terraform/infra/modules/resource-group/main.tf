resource "azurerm_resource_group" "main" {
  name     = "${var.prefix}-rg"
  location = var.location

  tags = {
    environment = "production"
    managed_by  = "terraform"
  }
}
