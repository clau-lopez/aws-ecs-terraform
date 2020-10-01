module "network" {
  source             = "./modules/network"
  application_name   = var.application_name
  vpc_cidr_block     = var.vpc_cidr_block
  availability_zones = var.availability_zones
  public_cidrs       = var.public_cidrs
  private_cidrs      = var.private_cidrs
}