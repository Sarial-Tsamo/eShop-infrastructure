variable "name_prefix" {
    description = "Prefix for all resource names"
    type        = string
}

variable "cidr_block" {
    description = "CIDR block for the VPC"
    type        = string
    default     = "10.0.0.0/16"
}

variable "az_count" {
    description = "Number of Availability Zones to use"
    type        = number
    default     = 2
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}