module "vpc" {
  source = "./modules/VPC"

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