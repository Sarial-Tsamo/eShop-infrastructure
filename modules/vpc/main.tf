module "vpc" {
    source = "../../modules/vpc"
    version = "~> 5.0"

    name_prefix = var.name_prefix
    cidr_block = "10.0.0.0/16"

    azs = [
        "${var.aws_region}a",
        "${var.aws_region}b"
    ]

    public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
    private_subnets = ["10.0.11.0/24", "10.0.12.0/24"]


    enable_nat_gateway = false
    single_nat_gateway = false

    enable_dns_hostnames = true
    enable_dns_support   = true
}
