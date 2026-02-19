provider "aws" {
    region = var.aws_region
}

locals {
    name_prefix = "eshop-${var.environment}"
}

module "vpc" {
    source = "../../modules/vpc"

    name_prefix = local.name_prefix
}

module "security" {
    source = "../../modules/security"

    name_prefix = local.name_prefix
    vpc_id     = module.vpc.vpc_id
}

module "rds" {
    source = "../../modules/rds"

    name_prefix     = local.name_prefix
    private_subnets = module.vpc.private_subnet_ids
    rds_sg_id       = module.security.rds_sg_id
    environment     = var.environment
    
    db_username    = "eshopadmin"
    db_password    = var.db_password
}

module "ecs" {
    source = "../../modules/ecs"

    name_prefix      = local.name_prefix
    public_subnets   = module.vpc.public_subnet_ids 
    ecs_sg_id        = module.security.ecs_sg_id
    environment      = var.environment

    db_endpoint      = module.rds.db_endpoint
    db_name          = module.rds.db_name
    db_username      = module.rds.db_username
    db_password      = var.db_password

    container_image  = "sarialbebeto/eshop-app:latest"
}


