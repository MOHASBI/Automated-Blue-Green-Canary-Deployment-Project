variable "github_repo" {
  description = "GitHub repository (owner/repo)"
  type        = string
  default     = "MOHASBI/Automated-Blue-Green-Canary-Deployment-Project"
}

variable "tf_state_bucket_name" {
  description = "S3 bucket name used for Terraform remote state"
  type        = string
  default     = "blue-green-848153448908-tf-state"
}

variable "tf_lock_table_name" {
  description = "DynamoDB table name used for Terraform state locking"
  type        = string
  default     = "terraform-state-lock"
}

variable "codedeploy_revisions_bucket_name" {
  description = "S3 bucket name that stores appspec.yml revisions for CodeDeploy"
  type        = string
  default     = "blue-green-848153448908-codedeploy-revisions"
}

variable "ecr_repository_name" {
  description = "ECR repository name for application container images"
  type        = string
  default     = "blue-green-app"
}

