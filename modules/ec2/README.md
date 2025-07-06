# EC2 Module

A Terraform module that provisions a complete EC2 instance setup with security groups, SSH key management, and automated dependency installation.

## Overview

This module creates a production-ready EC2 instance with comprehensive security configuration, automatic SSH key generation, and user data scripts for dependency installation. It's designed for web applications that require HTTP/HTTPS access and SSH connectivity.

## Features

- **EC2 Instance**: Ubuntu-based instance with configurable instance type
- **Security Groups**: Pre-configured security groups for HTTP, HTTPS, and SSH access
- **SSH Key Management**: Automatic generation and management of SSH key pairs
- **User Data Scripts**: Automated installation of Docker and dependencies
- **Resource Tagging**: Consistent tagging across all resources
- **Network Integration**: Designed to work with the network module

## Architecture

```
Internet
    │
    ▼
┌─────────────────┐
│ Security Group  │
│ - HTTP (80)     │
│ - HTTPS (443)   │
│ - SSH (22)      │
│ - All Egress    │
└─────────────────┘
    │
    ▼
┌─────────────────┐
│   EC2 Instance  │
│ - Ubuntu AMI    │
│ - Public IP     │
│ - User Data     │
└─────────────────┘
    │
    ▼
┌─────────────────┐
│ SSH Key Pair    │
│ - Auto-generated│
│ - Local storage │
└─────────────────┘
```

## Usage

### Basic Example

```hcl
module "ec2" {
  source = "./modules/ec2"

  environment        = "production"
  instance_name      = "foodtruck"
  instance_type      = "t3.micro"
  aws_region         = "us-east-1"
  ami_owner          = "099720109477"  # Canonical
  ubuntu_image_name  = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  subnet_id          = module.network.subnet.id
  vpc_id             = module.network.vpc.id
}
```

### Development Environment

```hcl
module "ec2" {
  source = "./modules/ec2"

  environment        = "development"
  instance_name      = "foodtruck-dev"
  instance_type      = "t2.micro"
  aws_region         = "us-east-1"
  ami_owner          = "099720109477"
  ubuntu_image_name  = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  subnet_id          = module.network.subnet.id
  vpc_id             = module.network.vpc.id
}
```

### Integration with Network Module

```hcl
module "network" {
  source = "./modules/network"

  environment   = "production"
  instance_name = "foodtruck"
  aws_region    = "us-east-1"
}

module "ec2" {
  source = "./modules/ec2"

  environment        = "production"
  instance_name      = "foodtruck"
  instance_type      = "t3.micro"
  aws_region         = "us-east-1"
  ami_owner          = "099720109477"
  ubuntu_image_name  = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
  subnet_id          = module.network.subnet.id
  vpc_id             = module.network.vpc.id
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |
| tls | >= 4.0 |
| local | >= 2.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |
| tls | >= 4.0 |
| local | >= 2.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | The environment name (e.g., development, staging, production) | `string` | n/a | yes |
| instance_name | The name prefix for all resources | `string` | n/a | yes |
| instance_type | The EC2 instance type | `string` | n/a | yes |
| aws_region | The AWS region where resources will be created | `string` | n/a | yes |
| ami_owner | The AWS account ID that owns the AMI | `string` | n/a | yes |
| ubuntu_image_name | The name pattern for the Ubuntu AMI | `string` | n/a | yes |
| subnet_id | The ID of the subnet where the instance will be launched | `string` | n/a | yes |
| vpc_id | The ID of the VPC where the security group will be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance | The complete EC2 instance resource object with all attributes |

## Resources Created

| Resource Type | Resource Name | Description |
|---------------|---------------|-------------|
| `random_id` | `id` | Random identifier for instance naming |
| `aws_instance` | `app_server` | Main EC2 instance |
| `tls_private_key` | `ssh_key` | SSH private key for instance access |
| `local_file` | `private_key` | Local storage of SSH private key |
| `local_file` | `public_key` | Local storage of SSH public key |
| `aws_key_pair` | `deployer` | AWS key pair for instance access |
| `aws_security_group` | `security_group` | Security group for instance |
| `aws_vpc_security_group_ingress_rule` | `http_ingress` | HTTP (80) ingress rule |
| `aws_vpc_security_group_ingress_rule` | `https_ingress` | HTTPS (443) ingress rule |
| `aws_vpc_security_group_ingress_rule` | `ssh_ingress` | SSH (22) ingress rule |
| `aws_vpc_security_group_egress_rule` | `all_egress` | All outbound traffic rule |

## Instance Configuration

### AMI Selection
- **Data Source**: Uses `aws_ami` data source to find the latest Ubuntu AMI
- **Owner**: Configurable AMI owner (default: Canonical - `099720109477`)
- **Image Pattern**: Configurable name pattern for Ubuntu images
- **Auto-update**: Instance recreates when AMI changes (via random_id keepers)

### Instance Settings
- **Instance Type**: Configurable (recommended: t3.micro for dev, t3.small+ for prod)
- **Public IP**: Automatically assigned
- **Subnet**: Placed in specified subnet
- **Key Pair**: Uses auto-generated SSH key pair
- **Security Groups**: Attached to instance with web and SSH access

### User Data Script
The instance automatically runs a user data script that:
- Waits for network connectivity
- Updates package lists
- Installs Docker and Docker Compose
- Configures Docker permissions
- Installs additional dependencies (curl, git, ca-certificates)

## Security Configuration

### Security Group Rules

| Type | Protocol | Port | Source | Description |
|------|----------|------|--------|-------------|
| Ingress | TCP | 80 | 0.0.0.0/0 | HTTP access |
| Ingress | TCP | 443 | 0.0.0.0/0 | HTTPS access |
| Ingress | TCP | 22 | 0.0.0.0/0 | SSH access |
| Egress | All | All | 0.0.0.0/0 | All outbound traffic |

### SSH Key Management
- **Auto-generation**: Creates RSA 4096-bit key pair
- **Local Storage**: Saves keys to `./.ssh/terraform_rsa` and `./.ssh/terraform_rsa.pub`
- **Permissions**: Private key has 0400 permissions
- **AWS Integration**: Uploads public key to AWS key pair

## Resource Tagging

All resources are automatically tagged with:
- `Name`: `{instance_name}-{random_hex}` (e.g., `foodtruck-a1b2c3`)
- `Environment`: The environment value provided

## License

This module is part of the FoodTruck infrastructure project.
