variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "tenant_id" {
  description = "The Azure Active Directory tenant ID"
  type        = string
}

variable "object_id" {
  description = "The Object ID of the executing user/service principal"
  type        = string
}
