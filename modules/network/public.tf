resource "aws_subnet" "public_subnet_1a" {
  vpc_id                  = aws_vpc.web_server_vpc.id
  availability_zone       = format("%sa", var.aws_region)
  cidr_block              = "10.0.0.0/20"
  map_public_ip_on_launch = true

  tags = {
    Name        = format("%s-public-subnet-1a", var.instance_name)
    Environment = var.environment
  }
}

resource "aws_route_table_association" "public_subnet_1a" {
  subnet_id      = aws_subnet.public_subnet_1a.id
  route_table_id = aws_route_table.igw_route_table.id
}
