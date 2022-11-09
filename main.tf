provider "aws" {
  region = var.aws_region
}

module "network" {
  source = "./modules/network"

  bigip_instance_type = var.bigip_instance_type
}
