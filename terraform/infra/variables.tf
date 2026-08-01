variable "location" {
  description = "The Azure region to deploy resources into"
  type        = string
  default     = "centralindia"
}

variable "prefix" {
  description = "Prefix for all resources to ensure unique names"
  type        = string
  default     = "erprod"
}

# ---------------------------------------------------------------
# Service Principal Authentication Variables
# In CI/CD, set these via TF_VAR_* environment variables.
# In local development, set them via a .tfvars file (never commit it).
# ---------------------------------------------------------------
variable "arm_subscription_id" {
  description = "Azure Subscription ID for Terraform authentication"
  type        = string
}

variable "arm_tenant_id" {
  description = "Azure Tenant ID for Terraform authentication"
  type        = string
}

variable "arm_client_id" {
  description = "Service Principal Client ID for Terraform authentication"
  type        = string
}

variable "arm_client_secret" {
  description = "Service Principal Client Secret for Terraform authentication"
  type        = string
  sensitive   = true
}
