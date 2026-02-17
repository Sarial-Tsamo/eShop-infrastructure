#######################
# ALB Scurity Group
#######################

resource "aws_security_group" "alb" {
  name = "${var.name_prefix}-alb-sg"
  description = "Security group for ALB"
  vpc_id = var.vpc_id

    ingress {
    description = "Allow HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
    description = "Allow HTTPS"
    from_port   = 443
    to_port     = 443   
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
    Name = "${var.name_prefix}-alb-sg"
    }
}

############################
# ECS Security Group
############################

resource "aws_security_group" "ecs" {
    name = "${var.name_prefix}-ecs-sg"
    description = "Security group for ECS"
    vpc_id = var.vpc_id

    ingress {
    description = "Allow traffic from ALB"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    security_groups = [aws_security_group.alb.id]
    }

    egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    }

    tags = {
        Name = "${var.name_prefix}-ecs-sg"
    }
}

#######################
# RDS Security Group
#######################

resource "aws_security_group" "rds" {
    name = "${var.name_prefix}-rds-sg"
    description = "RDS security group"
    vpc_id = var.vpc_id

    ingress {
    description = "Allow DB access from ECS"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    security_groups = [aws_security_group.ecs.id]
    }

    egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
    }

    tags = {
        Name = "${var.name_prefix}-rds-sg"
    }
}
