data "azurerm_client_config" "current" {}

module "resource_group" {
  source   = "./modules/resource-group"
  prefix   = var.prefix
  location = var.location
}

module "monitoring" {
  source              = "./modules/monitoring"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.resource_group.name
}

module "key_vault" {
  source              = "./modules/key-vault"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.resource_group.name
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = data.azurerm_client_config.current.object_id
}

module "storage" {
  source              = "./modules/storage"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.resource_group.name
}

module "postgres" {
  source              = "./modules/postgres"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.resource_group.name
  
  # Perfect example of Top-Down data flow: Grabbing the generated password 
  # from the key_vault module output and passing it into the postgres module!
  db_password         = module.key_vault.db_password
}

module "app_service_plan" {
  source              = "./modules/app-service-plan"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.resource_group.name
}

module "backend_app" {
  source              = "./modules/backend-app"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.resource_group.name
  app_service_plan_id = module.app_service_plan.plan_id
  
  database_connection_string = module.postgres.connection_string
  key_vault_uri              = module.key_vault.key_vault_uri
  key_vault_id               = module.key_vault.key_vault_id
  storage_account_name       = module.storage.storage_account_name
  storage_container_name     = module.storage.photos_container_name
  
  app_insights_instrumentation_key = module.monitoring.app_insights_instrumentation_key
  app_insights_connection_string   = module.monitoring.app_insights_connection_string
  acr_login_server                 = module.acr.acr_login_server
}

module "frontend_app" {
  source              = "./modules/frontend-app"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.resource_group.name
  app_service_plan_id = module.app_service_plan.plan_id
  
  # Injecting the Backend URL into the Frontend App!
  backend_hostname                 = module.backend_app.default_hostname
  app_insights_instrumentation_key = module.monitoring.app_insights_instrumentation_key
  app_insights_connection_string   = module.monitoring.app_insights_connection_string
  acr_login_server                 = module.acr.acr_login_server
}

module "acr" {
  source              = "./modules/acr"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = module.resource_group.name
}

# Grant Backend App permission to pull images from ACR
resource "azurerm_role_assignment" "backend_acr_pull" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.backend_app.principal_id
}

# Grant Frontend App permission to pull images from ACR
resource "azurerm_role_assignment" "frontend_acr_pull" {
  scope                = module.acr.acr_id
  role_definition_name = "AcrPull"
  principal_id         = module.frontend_app.principal_id
}

# Grant Backend App permission to read/write blobs in Storage Account
resource "azurerm_role_assignment" "backend_storage_blob_contributor" {
  scope                = module.storage.storage_account_id
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = module.backend_app.principal_id
}
