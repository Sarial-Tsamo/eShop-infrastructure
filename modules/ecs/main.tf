resource "aws_ecs_cluster" "this" {
    name = "${var.name_prefix}-cluster"
}

resource "aws_cloudwatch_log_group" "this" {
    name = "/ecs/${var.name_prefix}"
    retention_in_days = 7
}

resource "aws_iam_role" "task_execution_role" {
    name = "${var.name_prefix}-ecs-task-exec-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = "sts:AssumeRole"
                Effect = "Allow"
                Principal = {
                    Service = "ecs-tasks.amazonaws.com"
                }
            }
        ]
    })
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy" {
    role = aws_iam_role.task_execution_role.name
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_ecs_task_definition" "this" {
    family                    = "${var.name_prefix}-task"
    requires_compatibilities  = ["FARGATE"]
    network_mode              = "awsvpc"
    cpu                       = "256"
    memory                    = "512"
    execution_role_arn        = aws_iam_role.task_execution_role.arn

    container_definitions = jsonencode([
        {
            name       = "eshop-app"
            image      = var.container_image
            essential  = true
            portMappings = [
                {
                    containerPort = 8080
                    protocol      = "tcp"
                }
            ]
            environment = [
                {
                    name  = "DB_HOST"
                    value = var.db_endpoint
                },
                {
                    name  = "DB_NAME"
                    value = var.db_name
                },
                {
                    name  = "DB_USER"
                    value = var.db_username
                },
                {
                    name  = "DB_PASSWORD"
                    value = var.db_password
                }
            ]
            logConfiguration = {
                logDriver = "awslogs"
                options = {
                    awslogs-group       = aws_cloudwatch_log_group.this.name
                    awslogs-region      = "eu-central-1"
                    awslogs-stream-prefix  = "ecs"
                }
            }
        }
    ])
}


resource "aws_ecs_service" "this" {
    name                 = "${var.name_prefix}-service"
    cluster              = aws_ecs_cluster.this.id
    task_definition      = aws_ecs_task_definition.this.arn
    launch_type           = "FARGATE"
    desired_count        = 1

    network_configuration {
       subnets           = var.private_subnets
       security_groups   = [var.ecs_sg_id]
       assign_public_ip  = false
    }

    load_balancer {
      target_group_arn = var.target_group_arn
      container_name   = "eshop-app"
      container_port   = 8080
    }

    depends_on = [aws_ecs_task_definition.this]
}
               