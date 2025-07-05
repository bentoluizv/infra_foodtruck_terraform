terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

provider "aws" {
  profile = "default"
}

module "network" {
  source                   = "../../modules/network"
  vpc_cidr_block           = var.vpc_cidr_block
  public_subnet_cidr_block = var.public_subnet_cidr_block
}


module "ec2" {
  source      = "../../modules/ec2"
  environment = var.environment
  ami_owner   = var.ami_owner
  subnet_id   = module.network.subnet_id
}
