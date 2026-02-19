output "ecs_sg_id" {
   description = "ID of the ECS security group"
   value       = aws_security_group.ecs.id
}

output "rds_sg_id" {
    description = "ID of the RDS security group"
    value       = aws_security_group.rds.id
}