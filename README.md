# FoodTruck Infrastructure

A Terraform-based infrastructure project for deploying web applications on AWS with a modular, environment-based approach.

## Overview

This project provides a complete AWS infrastructure setup for web applications, featuring:
- **Modular Design**: Reusable Terraform modules for network and compute resources
- **Multi-Environment Support**: Separate configurations for local development and production
- **LocalStack Integration**: Local development environment using LocalStack
- **Security Best Practices**: Pre-configured security groups and SSH key management
- **Automated Deployment**: User data scripts for dependency installation

## Project Structure

```
infra/
├── environments/           # Environment-specific configurations
│   ├── local/             # LocalStack development environment
│   │   ├── main.tf        # Module orchestration
│   │   ├── variables.tf   # Local environment variables
│   │   └── provider.tf    # LocalStack provider configuration
│   └── production/        # Production AWS environment
│       ├── main.tf        # Module orchestration
│       ├── variables.tf   # Production environment variables
│       └── provider.tf    # AWS provider configuration
├── modules/               # Reusable Terraform modules
│   ├── network/          # VPC, subnets, and networking components
│   └── ec2/              # EC2 instances, security groups, and SSH keys
└── README.md             # This file
```

## Architecture

```
┌─────────────────────────────────────────────────────────────┐
│                    AWS Infrastructure                       │
├─────────────────────────────────────────────────────────────┤
│  Internet Gateway ── VPC (10.0.0.0/16) ── Public Subnet    │
│                                                             │
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │ Security Group  │    │   EC2 Instance  │                │
│  │ - HTTP (80)     │    │ - Ubuntu 22.04  │                │
│  │ - HTTPS (443)   │    │ - Public IP     │                │
│  │ - SSH (22)      │    │ - User Data     │                │
│  │ - All Egress    │    │ - Docker Ready  │                │
│  └─────────────────┘    └─────────────────┘                │
└─────────────────────────────────────────────────────────────┘
```

## Modules

### Network Module (`modules/network/`)
Creates the foundational networking infrastructure:
- **VPC**: Custom VPC with DNS support
- **Public Subnet**: Single public subnet with auto-assigned public IPs
- **Internet Gateway**: Provides internet connectivity
- **Route Table**: Configures routing for public internet access

**Key Features:**
- CIDR block: `10.0.0.0/16`
- Public subnet: `10.0.0.0/20`
- Auto-assigned public IPs
- DNS support enabled

### EC2 Module (`modules/ec2/`)
Deploys compute resources with comprehensive security:
- **EC2 Instance**: Ubuntu-based instance with configurable type
- **Security Groups**: Pre-configured for web and SSH access
- **SSH Key Management**: Auto-generated key pairs with local storage
- **User Data Scripts**: Automated Docker and dependency installation

**Key Features:**
- Ubuntu 22.04 AMI (latest)
- HTTP/HTTPS/SSH access
- Auto-generated SSH keys
- Docker installation via user data
- Comprehensive resource tagging

## Environments

### Local Development (`environments/local/`)
Configured for LocalStack development environment:
- **Provider**: LocalStack endpoints
- **Region**: `sa-east-1`
- **Instance Type**: `t2.micro`
- **AMI Owner**: `000000000000` (LocalStack)
- **Profile**: `localstack`

**Usage:**
```bash
cd environments/local
terraform init
terraform plan
terraform apply
```

### Production (`environments/production/`)
Configured for production AWS deployment:
- **Provider**: AWS
- **Region**: `sa-east-1`
- **Instance Type**: `t2.micro`
- **AMI Owner**: `099720109477` (Canonical)
- **Profile**: `default`

**Usage:**
```bash
cd environments/production
terraform init
terraform plan
terraform apply
```

## Prerequisites

### Required Software
- **Terraform**: >= 1.0
- **AWS CLI**: Configured with appropriate credentials
- **LocalStack**: For local development (optional)

### AWS Requirements
- AWS account with appropriate permissions
- IAM user/role with VPC and EC2 permissions
- AWS credentials configured

### LocalStack Setup (for local development)
```bash
# Install LocalStack
curl --output localstack-cli-4.6.0-linux-amd64-onefile.tar.gz \
    --location https://github.com/localstack/localstack-cli/releases/download/v4.6.0/localstack-cli-4.6.0-linux-amd64-onefile.tar.gz

sudo tar xvzf localstack-cli-4.6.0-linux-*-onefile.tar.gz -C /usr/local/bin


localstack start

```

## Quick Start

### 1. Clone the Repository
```bash
git clone <repository-url>
cd infra
```

### 2. Choose Environment
For local development:
```bash
cd environments/local
```

For production:
```bash
cd environments/production
```

### 3. Initialize Terraform
```bash
terraform init
```

### 4. Review the Plan
```bash
terraform plan
```

### 5. Apply the Configuration
```bash
terraform apply
```