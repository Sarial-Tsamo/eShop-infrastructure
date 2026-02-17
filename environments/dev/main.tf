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
