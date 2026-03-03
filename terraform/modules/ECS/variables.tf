variable "ecr_repo_url" {
  type = string
}

variable "private_subnets_id" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "alb_sg_id" {
  type = string
}

variable "target_group_arn" {
  type = string
}

variable "ecs_task_execution_role_arn" {
  type = string
}

variable "ecs_task_role_arn" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "task_cpu" {
  type = number
}

variable "task_memory" {
  type = number
}

variable "container_port" {
  type = number
}

variable "operating_system_family" {
  type = string
}

variable "cpu_architecture" {
  type = string
}

variable "log_group_name" {
  type = string
}

variable "log_retention_in_days" {
  type = number
}

variable "task_family" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_protocol" {
  type    = string
  default = "tcp"
}

variable "awslogs_stream_prefix" {
  type    = string
  default = "ecs"
}

variable "service_name" {
  type = string
}

variable "launch_type" {
  type    = string
  default = "FARGATE"
}

variable "platform_version" {
  type    = string
  default = "LATEST"
}

variable "desired_count" {
  type = number
}

variable "availability_zone_rebalancing" {
  type = string
}

variable "cluster_name" {
  type = string
}

variable "deployment_controller_type" {
  description = "ECS service deployment controller type (ECS or CODE_DEPLOY)"
  type        = string
  default     = "ECS"
}