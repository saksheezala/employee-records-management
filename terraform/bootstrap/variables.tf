variable "location" {
  description = "The Azure region to deploy resources into"
  type        = string
  default     = "centralindia"
}

variable "prefix" {
  description = "Prefix for all resources to ensure unique names"
  type        = string
  default     = "erboot"
}
