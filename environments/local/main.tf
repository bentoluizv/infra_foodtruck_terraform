
module "network" {
  source = "../../modules/network"

  instance_name = var.instance_name
  environment   = var.environment
  aws_region    = var.aws_region
}


module "ec2" {
  source = "../../modules/ec2"

  environment       = var.environment
  instance_name     = var.instance_name
  aws_region        = var.aws_region
  instance_type     = var.instance_type
  ami_owner         = var.ami_owner
  subnet_id         = module.network.subnet.id
  vpc_id            = module.network.vpc.id
  ubuntu_image_name = var.ubuntu_image_name
}
