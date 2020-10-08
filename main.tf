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
  container_port     = var.container_port
  bucket_prefix      = var.bucket_prefix
  vpc_id             = module.network.vpc_id
  public_subnets_ids = module.network.public_subnets_ids
}

module "ecr" {
  source           = "./modules/ecr"
  application_name = var.application_name
}

module "ecs" {
  source               = "./modules/ecs"
  application_name     = var.application_name
  container_port       = var.container_port
  vpc_id               = module.network.vpc_id
  repository_url       = module.ecr.repository_url
  private_subnets_ids  = module.network.private_subnets_ids
  aws_alb_target_group = module.alb.aws_alb_target_group
}

module "rds" {
  source              = "./modules/rds"
  application_name    = var.application_name
  allocated_storage   = var.allocated_storage
  instance_class      = var.instance_class
  engine_version      = var.engine_version
  database_name       = var.database_name
  private_cidrs       = var.private_cidrs
  private_subnets_ids = module.network.private_subnets_ids
  vpc_id              = module.network.vpc_id
}