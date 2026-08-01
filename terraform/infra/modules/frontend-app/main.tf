resource "azurerm_linux_web_app" "main" {
  name                = "${var.prefix}-ui"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.app_service_plan_id

  # Required to authenticate against ACR
  identity {
    type = "SystemAssigned"
  }

  site_config {
    container_registry_use_managed_identity = true
    application_stack {
      docker_image_name   = "frontend:latest"
      docker_registry_url = "https://${var.acr_login_server}"
    }
  }

  app_settings = {
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"   = "false"
    "WEBSITES_PORT"                         = "5173"
    # Provide the React app with the Backend API URL!
    "VITE_API_URL"                          = "https://${var.backend_hostname}"
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = var.app_insights_instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.app_insights_connection_string
  }

  tags = {
    environment = "production"
  }

  lifecycle {
    ignore_changes = [
      site_config[0].application_stack[0].docker_image_name,
    ]
  }
}
