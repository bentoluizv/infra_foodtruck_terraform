resource "aws_vpc" "web_server_vpc" {
  cidr_block = var.vpc_cidr_block

  tags = {
    Name = "Web Server VPC"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.web_server_vpc.id
  cidr_block              = var.public_subnet_cidr_block
  map_public_ip_on_launch = true
}

resource "aws_internet_gateway" "web_server_ig" {
  vpc_id = aws_vpc.web_server_vpc.id

  tags = {
    Name = "Web Server VPC IG"
  }
}

resource "aws_route_table" "web_server_route_table" {
  vpc_id = aws_vpc.web_server_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.web_server_ig.id
  }

  tags = {
    Name = "Web Server Route Table"
  }
}

resource "aws_route_table_association" "web_server_route_table_association" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.web_server_route_table.id
}
