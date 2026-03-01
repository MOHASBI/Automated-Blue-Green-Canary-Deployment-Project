variable "ecs_execution_role_name" {
  type = string
}

variable "ecs_execution_policy_arn" {
  type = string
}

variable "task_service_principals" {
  type = list(string)
}

variable "ecs_task_role_name" {
  description = "Name of the ECS task IAM role"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "ARN of the DynamoDB table the task should access"
  type        = string
}

variable "codedeploy_role_name" {
  description = "Name of the IAM role for CodeDeploy"
  type        = string
  default     = "codedeploy-role-url-shortener"
}