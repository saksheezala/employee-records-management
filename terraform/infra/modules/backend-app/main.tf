resource "azurerm_linux_web_app" "main" {
  name                = "${var.prefix}-api"
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.app_service_plan_id
  
  # Enable System Assigned Identity so this App Service can authenticate itself to Key Vault
  identity {
    type = "SystemAssigned"
  }

  site_config {
    container_registry_use_managed_identity = true
    application_stack {
      docker_image_name   = "backend:latest"
      docker_registry_url = "https://${var.acr_login_server}"
    }
  }

  app_settings = {
    # Environment Variables for the Node.js application
    "WEBSITES_ENABLE_APP_SERVICE_STORAGE"   = "false" # Best practice for containers
    "WEBSITES_PORT"                         = "3000"
    "DATABASE_URL"                          = var.database_connection_string
    "KEY_VAULT_URI"                         = var.key_vault_uri
    "STORAGE_ACCOUNT_NAME"                  = var.storage_account_name
    "STORAGE_CONTAINER_NAME"                = var.storage_container_name
    "APPINSIGHTS_INSTRUMENTATIONKEY"        = var.app_insights_instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING" = var.app_insights_connection_string
    "NODE_ENV"                              = "production"
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

# Grant the App Service's Managed Identity read access to Key Vault
resource "azurerm_key_vault_access_policy" "backend_kv_access" {
  key_vault_id = var.key_vault_id
  tenant_id    = azurerm_linux_web_app.main.identity[0].tenant_id
  object_id    = azurerm_linux_web_app.main.identity[0].principal_id

  secret_permissions = [
    "Get",
    "List",
  ]
}
