variable "cluster_name" {
  description = "ECS cluster name"
  type        = string
}

variable "service_name" {
  description = "ECS service name"
  type        = string
}

variable "listener_arn" {
  description = "ALB listener ARN for prod traffic route"
  type        = string
}

variable "blue_tg_name" {
  description = "Blue target group name"
  type        = string
}

variable "green_tg_name" {
  description = "Green target group name"
  type        = string
}

variable "app_name" {
  description = "CodeDeploy application name"
  type        = string
}

variable "deployment_group_name" {
  description = "CodeDeploy deployment group name"
  type        = string
}

variable "codedeploy_service_role_arn" {
  description = "ARN of the IAM role for CodeDeploy (from IAM module)"
  type        = string
}