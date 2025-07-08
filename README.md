# FoodTruck Infrastructure

A Terraform-based infrastructure project for deploying web applications on AWS with a modular, environment-based approach.

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

┌─────────────────────────────────────────────────────────────┐
│                 Terraform Backend Storage                   │
├─────────────────────────────────────────────────────────────┤
│  ┌─────────────────┐    ┌─────────────────┐                │
│  │   S3 Bucket     │    │  DynamoDB Table │                │
│  │ - State Files   │    │ - State Locking │                │
│  │ - Backend Config│    │ - LockID Key    │                │
│  │ - Environment   │    │ - Pay-per-Request│               │
│  └─────────────────┘    └─────────────────┘                │
└─────────────────────────────────────────────────────────────┘
```

## Environments

### Local Development (`environments/local/`)
Configured for LocalStack development environment:
- **Provider**: LocalStack endpoints
- **Region**: `sa-east-1`
- **Instance Type**: `t2.micro`
- **AMI Owner**: `000000000000` (LocalStack)
- **Profile**: `localstack`
- **Backend**: S3 bucket and DynamoDB table for state management

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
- **Backend**: S3 bucket and DynamoDB table for state management

**Usage:**
```bash
cd environments/production
terraform init
terraform plan
terraform apply
```

## Terraform Backend Configuration

This infrastructure uses S3 and DynamoDB for Terraform state management:

### S3 Backend Storage
- **Bucket Name**: `terraform-lock-backend`
- **Purpose**: Stores Terraform state files
- **Benefits**:
  - Version control for state files
  - Team collaboration
  - State file backup and recovery

### DynamoDB State Locking
- **Table Name**: `terraform-lock-backend`
- **Hash Key**: `LockID`
- **Purpose**: Prevents concurrent state modifications
- **Benefits**:
  - Prevents state corruption
  - Enables team collaboration
  - Provides state locking mechanism
