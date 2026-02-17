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