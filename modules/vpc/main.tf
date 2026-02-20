data "aws_availability_zones" "available" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)
}

########################
# VPC
########################

resource "aws_vpc" "this" {
    cidr_block        = var.vpc_cidr_block
    enable_dns_hostnames = true
    enable_dns_support   = true

    tags = {
        Name = "${var.name_prefix}-vpc"
    }
}

########################
# Public Subnets
########################

resource "aws_subnet" "public" {
   count  = 2

   vpc_id                   = aws_vpc.this.id
   cidr_block               = cidrsubnet(var.vpc_cidr_block, 8, count.index)
   availability_zone        = local.azs[count.index]
   map_public_ip_on_launch  = true

   tags = {
     Name = "${var.name_prefix}-public-${count.index + 1}"
    }
}

#########################
# Private Subnets
#########################

resource "aws_subnet" "private" {

  count = 2

  vpc_id             = aws_vpc.this.id
  cidr_block         = cidrsubnet(var.vpc_cidr, 8, count.index + 10)
  availability_zone  = local.azs[count.index]

  tags = {
    Name = "${var.name_prefix}-private-${count.index + 1}"
  }
} 

#######################
# IgW
######################

resource "aws_internet_gateway"  "this"{
 vpc_id  = aws_vpc.this.id

 tags = {
  Name = "${var.name_prefix}-igw"
  }
}


##########################
# Public Route Table
##########################

resource "aws_route_table" "public" {
 vpc_id   = aws_vpc.this.id

 tags = { 
  Name = "${var.name_prefix}-public-rt"
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id           = aws_route_table.public.id
  destination_cidr_block   = "0.0.0.0/0"
  gateway_id               = aws_internet_gateway.this.id
}

resource "aws_route_table_association" "public_assoc" {
  count = 2
  subnet_id         = aws_subnet.public[count.index].id
  route_table_id    = aws_route_table.public.id
}

##########################
# Private Route Table
##########################

resource "aws_route_table" "private" {
  vpc_id  = aws_vpc.this.id

  tags =  {
   Name  = "${var.name_prefix}-private-rt"
   }
}

resource "aws_route_table_association" "private_assoc" {
  count = 2

  subnet_id   = aws_subnet.private[count.index].id
  route_table_id  = aws_route_table.private.id
}

