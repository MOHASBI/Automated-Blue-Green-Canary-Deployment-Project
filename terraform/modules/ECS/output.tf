output "cluster_id" {
  value = aws_ecs_cluster.ecs.id
}

output "cluster_name" {
  description = "ECS cluster name"
  value       = aws_ecs_cluster.ecs.name
}

output "task_definition_arn" {
  description = "ECS task definition ARN"
  value       = aws_ecs_task_definition.task_definition.arn
}

output "service_name" {
  value = aws_ecs_service.service.name
}

output "service_arn" {
  description = "ECS service ARN"
  value       = aws_ecs_service.service.id
}