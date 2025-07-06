output "vpc" {
  description = "The VPC"
  value       = aws_vpc.web_server_vpc
}

output "subnet" {
  description = "The public subnet"
  value       = aws_subnet.public_subnet_1a
}

output "internet_gateway" {
  description = "The internet gateway"
  value       = aws_internet_gateway.igw
}

output "route_table" {
  description = "The route table"
  value       = aws_route_table.igw_route_table
}
