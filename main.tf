module "network" {
  source           = "./modules/network"
  application_name = var.application_name
  vpc_cidr_block   = var.vpc_cidr_block
}