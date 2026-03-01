variable "aws_region" {
  type    = string
  default = "eu-west-2"
}

variable "project_name" {
  type    = string
  default = "ecs-url-shortener"
}

variable "image_tag" {
  type    = string
  default = "latest"
}

variable "task_cpu" {
  type    = number
  default = 1024
}

variable "task_memory" {
  type    = number
  default = 3072
}

variable "container_port" {
  type    = number
  default = 8000
}

variable "desired_count" {
  type    = number
  default = 2
}

variable "log_retention_in_days" {
  type    = number
  default = 7
}

variable "availability_zone_rebalancing" {
  type    = string
  default = "ENABLED"
}

variable "operating_system_family" {
  type    = string
  default = "LINUX"
}

variable "cpu_architecture" {
  type    = string
  default = "X86_64"
}

variable "target_port" {
  type    = number
  default = 8000
}

variable "health_check_path" {
  type    = string
  default = "/healthz"
}

variable "health_check_matcher" {
  type    = string
  default = "200"
}

variable "ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "zone_name" {
  type    = string
  default = "mohamedhassanproject.com"
}

variable "record_name" {
  type    = string
  default = "tm"
}

variable "record_type" {
  type    = string
  default = "A"
}

variable "load_balancer_type" {
  type    = string
  default = "application"
}

variable "domain_name" {
  type    = string
  default = "tm.mohamedhassanproject.com"
}

variable "private_zone" {
  type    = bool
  default = false
}

variable "cert_validation_ttl" {
  type    = number
  default = 300
}

variable "public_subnet_cidrs" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(any)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  type    = list(any)
  default = ["eu-west-2a", "eu-west-2b"]
}

variable "ecs_execution_role_name" {
  type    = string
  default = "ecs-url-shortener-ExecutionRole"
}

variable "ecs_execution_policy_arn" {
  type    = string
  default = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

variable "task_service_principals" {
  type    = list(string)
  default = ["ecs-tasks.amazonaws.com"]
}

variable "table_name" {
  description = "DynamoDB table name"
  type        = string
  default     = "url-shortener"
}

variable "ecs_task_role_name"{
  type    = string
  default = "ecs-url-shortener-taskrole"
}

variable "app_name" {
  description = "CodeDeploy application name"
  type        = string
  default     = "url-shortener-codedeploy-app"
}

variable "deployment_group_name" {
  description = "CodeDeploy deployment group name"
  type        = string
  default     = "url-shortener-dg"
}

variable "github_repo" {
  description = "GitHub repository name"
  type        = string
  default     = "MOHASBI/Automated-Blue-Green-Canary-Deployment-Project"
}



