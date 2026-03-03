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