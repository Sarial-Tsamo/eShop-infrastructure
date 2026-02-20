variable "aws_region" {
  description = "The AWS region where resources will be created."
  type        = string
  default     = "eu-central-1"
}

variable "environment" {
  description = "The deployment environment (e.g., dev, staging, prod)."
  type        = string
  default     = "dev"
}

variable "db_password" {
  description = "The password for the RDS database."
  type        = string
  sensitive   = true
}

variable "container_image" {
  type = string
}

variable "database_url" {
 type = string
}

variable "name_prefix" {
  type = string
  default = "eshop-${var.environment}"
}
