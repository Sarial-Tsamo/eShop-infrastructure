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
