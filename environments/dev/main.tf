provider "aws" {
    region = var.aws_region
}

locals {
    name_prefix = "eshop-${var.environment}"
}