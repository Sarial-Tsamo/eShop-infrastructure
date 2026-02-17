#################
# Subnet Group
#################

resource "aws_db_subnet_group" "this" {
    name       = "${var.name_prefix}-db-subnet-group"
    subnet_ids = var.private_subnets

    tags = {
        Name     = "${var.name_prefix}-db-subnet-group"
    }
}

#################
# RDS Instance
##################

resource "aws_db_instance" "this" {
    identifier              = "${var.name_prefix}-postgres"
    engine                  = "postgres"
    engine_version          = "15"
    instance_class          = var.db_instance_class
    allocated_storage       = 20
    storage_encrypted       = true
    
    db_name                 = var.db_name
    username                = var.db_username
    password                = var.db_password

    vpc_security_group_ids  = [var.rds_sg_id]
    db_subnet_group_name   = aws_db_subnet_group.this.name

    publicly_accessible     = false
    multi_az                = var.environment == "prod" ? true : false

    backup_retention_period = var.environment == "prod" ? 7 : 1
    skip_final_snapshot     = var.environment == "dev" ? true : false
    deletion_protection     = var.environment == "prod" ? true : false

    performance_insights_enabled = true

    tags = {
        Name        = "${var.name_prefix}-postgres"
        Environment = var.environment
    }
}

