output "task_definition_arn" {
  description = "ARN of the ECS task definition"
  value       = aws_ecs_task_definition.ecs_task.arn
}

output "service_name" {
  description = "Name of the ECS service"
  value       = aws_ecs_service.ecs_service.name
}