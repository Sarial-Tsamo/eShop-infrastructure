variable "name_prefix" {
    description = "Prefix for the RDS instance name."
    type        = string
}

variable "private_subnets" {
    description = "List of private subnet IDs for the RDS instance."
    type        = list(string)
}

variable "rds_sg_id" {
    type        = string
}

variable "db_name" {
    description = "The name of the database to create when the DB instance is created."
    type        = string
    default     = "eshop_db"
}

variable "db_username" {
    description = "The username for the database."
    type        = string
}

variable "db_password" {
    description = "The password for the database."
    type        = string
    sensitive   = true
}

variable "db_instance_class" {
    description = "The compute and memory capacity of the DB instance."
    type        = string
    default     = "db.t3.micro"
}

variable "environment" {
    type       = string
}
