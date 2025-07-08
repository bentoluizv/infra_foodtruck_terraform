terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }

  backend "s3" {
    bucket           = "terraform-lock-backend"
    key              = "tfkey/terraform.tfstate"
    region           = "sa-east-1"
    force_path_style = true
    encrypt          = true
    use_lockfile     = true
  }
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}
