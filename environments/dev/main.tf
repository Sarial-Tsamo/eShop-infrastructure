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
    rds_sg_id      = module.security.rds_sg_id
     environment    = var.environment
    
    db_username    = "eshopadmin"
    db_password    = var.db_password
}