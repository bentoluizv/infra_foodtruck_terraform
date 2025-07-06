# Network Module

A Terraform module that creates a basic VPC infrastructure with public internet access for web applications.

## Overview

This module provisions a complete VPC setup with public networking capabilities, designed for simple web server deployments that require direct internet connectivity.

## Features

- **VPC**: Custom VPC with DNS support and hostnames enabled
- **Public Subnet**: Single public subnet with auto-assigned public IPs
- **Internet Gateway**: Provides internet connectivity for the VPC
- **Route Table**: Configures routing for public internet access
- **Resource Tagging**: Consistent tagging across all resources

## Architecture

```
Internet
    │
    ▼
┌─────────────────┐
│ Internet Gateway│
│   (igw)         │
└─────────────────┘
    │
    ▼
┌─────────────────┐
│      VPC        │
│  10.0.0.0/16    │
│ (web_server_vpc)│
└─────────────────┘
    │
    ▼
┌──────────────────────────┐
│  Public Subnet           │
│  10.0.0.0/20             │
│ (public_subnet_1a)       │
│ (Auto-assign Public IPs) │
└──────────────────────────┘
```

## Usage

### Basic Example

```hcl
module "network" {
  source = "./modules/network"

  environment   = "production"
  instance_name = "foodtruck"
  aws_region    = "us-east-1"
}
```

### Development Environment

```hcl
module "network" {
  source = "./modules/network"

  environment   = "development"
  instance_name = "foodtruck-dev"
  aws_region    = "us-west-2"
}
```

### Integration with EC2 Module

```hcl
module "network" {
  source = "./modules/network"

  environment   = "production"
  instance_name = "foodtruck"
  aws_region    = "us-east-1"
}

module "ec2" {
  source = "./modules/ec2"

  environment = "production"
  subnet_id   = module.network.subnet.id
  vpc_id      = module.network.vpc.id
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
| environment | The environment name (e.g., production, development, staging) | `string` | n/a | yes |
| instance_name | The name prefix for all resources | `string` | n/a | yes |
| aws_region | The AWS region where resources will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| vpc | The VPC resource object with all attributes |
| subnet | The public subnet resource object with all attributes |
| internet_gateway | The internet gateway resource object with all attributes |
| route_table | The route table resource object with all attributes |

## Resources Created

| Resource Type | Resource Name | Description |
|---------------|---------------|-------------|
| `aws_vpc` | `web_server_vpc` | Main VPC with CIDR block 10.0.0.0/16 |
| `aws_subnet` | `public_subnet_1a` | Public subnet in availability zone 1a (10.0.0.0/20) |
| `aws_internet_gateway` | `igw` | Internet Gateway attached to the VPC |
| `aws_route_table` | `igw_route_table` | Route table for public internet access |
| `aws_route` | `public_internet_access` | Default route (0.0.0.0/0) to internet gateway |
| `aws_route_table_association` | `public_subnet_1a` | Associates route table with public subnet |

## Network Configuration

### VPC Settings
- **CIDR Block**: `10.0.0.0/16`
- **DNS Support**: Enabled
- **DNS Hostnames**: Enabled

### Subnet Settings
- **CIDR Block**: `10.0.0.0/20`
- **Availability Zone**: `{aws_region}a` (e.g., us-east-1a)
- **Auto-assign Public IPs**: Enabled
- **Route Table**: Associated with public route table

### Routing
- **Default Route**: `0.0.0.0/0` → Internet Gateway
- **Route Table**: Public route table with internet access

## Resource Tagging

All resources are automatically tagged with:
- `Name`: `{instance_name}-{resource-type}` (e.g., `foodtruck-vpc`)
- `Environment`: The environment value provided

## License

This module is part of the FoodTruck infrastructure project.
