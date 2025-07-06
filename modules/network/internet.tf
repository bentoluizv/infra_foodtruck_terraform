resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.web_server_vpc.id

  tags = {
    Name        = format("%s-igw", var.instance_name)
    Environment = var.environment
  }
}


resource "aws_route_table" "igw_route_table" {
  vpc_id = aws_vpc.web_server_vpc.id

  tags = {
    Name        = format("%s-public-route", var.instance_name)
    Environment = var.environment
  }
}

resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.igw_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
