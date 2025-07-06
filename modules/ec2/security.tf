resource "aws_security_group" "security_group" {
  vpc_id = var.vpc_id

  tags = {
    Name        = format("%s-security-group", var.instance_name)
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "http_ingress" {
  security_group_id = aws_security_group.security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80

  tags = {
    Name        = format("%s-http-ingress", var.instance_name)
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "https_ingress" {
  security_group_id = aws_security_group.security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443

  tags = {
    Name        = format("%s-https-ingress", var.instance_name)
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh_ingress" {
  security_group_id = aws_security_group.security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 22
  ip_protocol = "tcp"
  to_port     = 22

  tags = {
    Name        = format("%s-ssh-ingress", var.instance_name)
    Environment = var.environment
  }
}

resource "aws_vpc_security_group_egress_rule" "all_egress" {
  security_group_id = aws_security_group.security_group.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  tags = {
    Name        = format("%s-all-egress", var.instance_name)
    Environment = var.environment
  }
}


