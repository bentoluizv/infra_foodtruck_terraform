resource "aws_vpc" "web_server_vpc" {
  cidr_block = "10.0.0.0/16"

  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = format("%s-vpc", var.instance_name)
    Environment = var.environment
  }
}


