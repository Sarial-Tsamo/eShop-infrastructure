variable "name_prefix" {
    type = string
}

variable "ecs_sg_id" {
    type = string 
}

variable "db_endpoint" {
    type = string
}

variable "db_name" {
    type = string
}

variable "db_username" {
    type = string
}

variable "db_password" {
    type = string
}

variable "container_image" {
    type = string
}

variable "environment" {
    type = string
}

variable "private_subnets" {
   type = list(string)
}

variable "database_url" {
   type   = string
}

