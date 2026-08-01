variable "prefix" { type = string }
variable "location" { type = string }
variable "resource_group_name" { type = string }
variable "app_service_plan_id" { type = string }
variable "database_connection_string" { type = string }
variable "key_vault_uri" { type = string }
variable "key_vault_id" { type = string }
variable "storage_account_name" {
  type        = string
  description = "The name of the Azure Storage Account"
}
variable "storage_container_name" { type = string }
variable "app_insights_instrumentation_key" { type = string }
variable "app_insights_connection_string" { type = string }
variable "acr_login_server" { type = string }
