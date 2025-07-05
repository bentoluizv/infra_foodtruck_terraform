data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = [var.ami_owner]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-*"]
  }
}

resource "random_id" "id" {
  byte_length = 6
  prefix      = var.environment
  keepers = {
    ami = data.aws_ami.ubuntu.id
  }
}

resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true

  tags = {
    Name = "app-server-${random_id.id.hex}"
  }
}

