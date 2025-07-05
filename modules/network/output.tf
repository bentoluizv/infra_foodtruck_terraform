output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.web_server_vpc.id
}

output "vpc_cidr_block" {
  description = "The CIDR block of the VPC"
  value       = aws_vpc.web_server_vpc.cidr_block
}

output "subnet_id" {
  description = "The ID of the public subnet"
  value       = aws_subnet.public_subnet.id
}

output "subnet_cidr_block" {
  description = "The CIDR block of the public subnet"
  value       = aws_subnet.public_subnet.cidr_block
}

output "internet_gateway_id" {
  description = "The ID of the internet gateway"
  value       = aws_internet_gateway.web_server_ig.id
}

output "route_table_id" {
  description = "The ID of the route table"
  value       = aws_route_table.web_server_route_table.id
}
