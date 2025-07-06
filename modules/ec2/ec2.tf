resource "random_id" "id" {
  byte_length = 6

  keepers = {
    ami = data.aws_ami.ubuntu.id
  }
}


resource "aws_instance" "app_server" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.deployer.key_name
  security_groups             = [aws_security_group.security_group.id]

  user_data = file("${path.module}/scripts/install_dependencies.sh")

  tags = {
    Name        = format("%s-%s", var.instance_name, random_id.id.hex)
    Environment = var.environment
  }
}

