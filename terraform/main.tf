module "vpc" {
  source = "./modules/vpc"

  region              = var.aws_region
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
}

module "acm" {
  source = "./modules/ACM"

  domain_name        = var.domain_name
  hosted_zone_name   = var.zone_name
  private_zone       = var.private_zone
  cert_validation_ttl = var.cert_validation_ttl
}

module "alb" {
  source = "./modules/ALB"

  vpc_id            = module.vpc.vpc_id
  public_subnets_id = module.vpc.public_subnets_id
  acm_certificate_arn = module.acm.acm_certificate_arn
  target_port       = var.target_port
  health_check_path = var.health_check_path
  health_check_matcher = var.health_check_matcher
  ssl_policy        = var.ssl_policy
  zone_name         = var.zone_name
  record_name       = var.record_name
  record_type       = var.record_type
  load_balancer_type = var.load_balancer_type
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.table_name
}

module "iam" {
  source = "./modules/IAM"

  ecs_execution_role_name  = var.ecs_execution_role_name
  ecs_execution_policy_arn = var.ecs_execution_policy_arn
  task_service_principals  = var.task_service_principals
  ecs_task_role_name       = var.ecs_task_role_name
  dynamodb_table_arn       = module.dynamodb.table_arn
}

module "ecs" {
  source = "./modules/ECS"

  ecr_repo_url              = data.terraform_remote_state.bootstrap.outputs.ecr_repository_url
  private_subnets_id        = module.vpc.private_subnets_id
  vpc_id                    = module.vpc.vpc_id
  alb_sg_id                 = module.alb.alb_sg_id
  target_group_arn          = module.alb.blue_target_group_arn
  ecs_task_execution_role_arn = module.iam.ecs_task_execution_role_arn
  ecs_task_role_arn         = module.iam.ecs_task_role_arn
  aws_region                = var.aws_region
  task_cpu                  = var.task_cpu
  task_memory               = var.task_memory
  container_port            = var.container_port
  operating_system_family   = var.operating_system_family
  cpu_architecture          = var.cpu_architecture
  log_group_name            = "${var.project_name}-logs"
  log_retention_in_days     = var.log_retention_in_days
  task_family               = "${var.project_name}-task"
  image_tag                 = var.image_tag
  container_name            = "${var.project_name}-container"
  service_name              = "${var.project_name}-service"
  desired_count             = var.desired_count
  availability_zone_rebalancing = var.availability_zone_rebalancing
  cluster_name              = "${var.project_name}-cluster"
  deployment_controller_type = "CODE_DEPLOY"
}

module "codedeploy" {
  source = "./modules/codedeploy"

  cluster_name             = module.ecs.cluster_name
  service_name             = module.ecs.service_name
  listener_arn             = module.alb.https_listener_arn
  blue_tg_name             = module.alb.blue_tg_name
  green_tg_name            = module.alb.green_tg_name
  app_name                 = var.app_name
  deployment_group_name    = var.deployment_group_name
  codedeploy_service_role_arn = module.iam.codedeploy_role_arn
}

data "terraform_remote_state" "bootstrap" {
      backend = "s3"
  config = {
        bucket = "blue-green-848153448908-tf-state"
    key    = "Bootstrap/terraform.tfstate"
    region = "eu-west-2"
  }
}