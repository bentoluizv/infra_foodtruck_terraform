
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

module "s3" {
  source = "../../modules/s3"

  bucket_name = "terraform-lock-backend"
  environment = var.environment
}

module "dynamodb" {
  source         = "../../modules/dynamodb"
  environment    = var.environment
  table_name     = "terraform-lock-backend"
  hash_key       = "LockID"
  attribute_name = "LockID"
  attribute_type = "S"
}
