# Network Module

This Terraform module creates a basic VPC infrastructure for web servers with public internet access.

## Description

The Network module provisions a complete VPC setup with the following components:
- VPC with configurable CIDR block
- Public subnet with auto-assigned public IPs
- Internet Gateway for internet connectivity
- Route table with default route to internet
- Route table association for the public subnet

## Usage

### Basic Usage

```hcl
module "network" {
  source = "./modules/network"
}
```

### Custom CIDR Blocks

```hcl
module "network" {
  source = "./modules/network"

  vpc_cidr_block           = "172.16.0.0/16"
  public_subnet_cidr_block = "172.16.1.0/24"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vpc_cidr_block | The CIDR block for the VPC | `string` | `"10.0.0.0/28"` | no |
| public_subnet_cidr_block | The CIDR block for the public subnet | `string` | `"10.0.0.0/28"` | no |

## Outputs

| Name | Description |
|------|-------------|
| vpc_id | The ID of the VPC |
| vpc_cidr_block | The CIDR block of the VPC |
| subnet_id | The ID of the public subnet |
| subnet_cidr_block | The CIDR block of the public subnet |
| internet_gateway_id | The ID of the internet gateway |
| route_table_id | The ID of the route table |

## Resources Created

| Resource | Name | Description |
|----------|------|-------------|
| aws_vpc | web_server_vpc | Main VPC for the web server infrastructure |
| aws_subnet | public_subnet | Public subnet with auto-assigned public IPs |
| aws_internet_gateway | web_server_ig | Internet Gateway for VPC internet connectivity |
| aws_route_table | web_server_route_table | Route table with default route to internet |
| aws_route_table_association | web_server_route_table_association | Associates the route table with the public subnet |

## Examples

### Development Environment

```hcl
module "network_dev" {
  source = "./modules/network"

  vpc_cidr_block           = "10.0.0.0/16"
  public_subnet_cidr_block = "10.0.1.0/24"
}
```

### Production Environment

```hcl
module "network_prod" {
  source = "./modules/network"

  vpc_cidr_block           = "172.16.0.0/16"
  public_subnet_cidr_block = "172.16.1.0/24"
}
```

### Using with EC2 Module

```hcl
module "network" {
  source = "./modules/network"
}

module "ec2" {
  source = "./modules/ec2"

  environment = "production"
  # Note: You would need to add subnet_id variable to EC2 module
  # subnet_id = module.network.subnet_id
}
```

## Network Architecture

```
Internet
    │
    ▼
┌─────────────────┐
│ Internet Gateway│
└─────────────────┘
    │
    ▼
┌─────────────────┐
│      VPC        │
│  10.0.0.0/28    │
└─────────────────┘
    │
    ▼
┌─────────────────┐
│  Public Subnet  │
│  10.0.0.0/28    │
│ (Auto-assign    │
│  Public IPs)    │
└─────────────────┘
```

## Notes

- The VPC and subnet use the same CIDR block by default (`10.0.0.0/28`)
- The public subnet has `map_public_ip_on_launch = true` for automatic public IP assignment
- The route table includes a default route (`0.0.0.0/0`) to the internet gateway
- All resources are tagged with descriptive names for easy identification
- This module is designed for simple web server deployments with public internet access

## Security Considerations

- This module creates a public-facing network infrastructure
- Consider adding security groups to control traffic flow
- For production environments, consider implementing a more complex network architecture with private subnets
- The current setup allows all outbound internet traffic and inbound traffic based on security group rules

## License

This module is part of the FoodTruck infrastructure project.
