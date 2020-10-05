module "network" {
  source             = "./modules/network"
  application_name   = var.application_name
  vpc_cidr_block     = var.vpc_cidr_block
  availability_zones = var.availability_zones
  public_cidrs       = var.public_cidrs
  private_cidrs      = var.private_cidrs
}

module "alb" {
  source             = "./modules/alb"
  application_name   = var.application_name
  insecure_port      = var.insecure_port
  secure_port        = var.secure_port
  bucket_prefix      = var.bucket_prefix
  vpc_id             = module.network.vpc_id
  public_subnets_ids = module.network.public_subnets_ids
}

module "ecr" {
  source           = "./modules/ecr"
  application_name = var.application_name
}