module "vpc" {
  source = "./modules/VPC"

  region              = var.aws_region
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones  = var.availability_zones
}