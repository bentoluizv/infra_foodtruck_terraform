# EC2 Module

This Terraform module provisions an EC2 instance in AWS with configurable parameters for different environments.

## Description

The EC2 module creates a single EC2 instance with the following features:
- Ubuntu 22.04 AMI (configured for Localstack compatibility)
- Environment-based naming with random suffixes
- Basic tagging for resource identification
- Outputs for instance details (ID, public IP, DNS)

## Usage

### Basic Usage

```hcl
module "ec2" {
  source = "./modules/ec2"

  environment = "production"
}
```

### Advanced Usage

```hcl
module "ec2" {
  source = "./modules/ec2"

  environment    = "staging"
  instance_type  = "t3.small"               # Larger instance type
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 5.0 |
| random | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 5.0 |
| random | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| environment | The environment name (e.g., development, staging, production) | `string` | n/a | yes |
| instance_type | The EC2 instance type | `string` | `"t2.micro"` | no |

### AMI Configuration

The module uses a data source to automatically find the latest Ubuntu 22.04 AMI from Localstack:
- Owner: Localstack (`000000000000`)
- Name pattern: `ubuntu-22.04-jammy-jellyfish`

## Outputs

| Name | Description |
|------|-------------|
| instance_id | The ID of the EC2 instance |
| instance_public_ip | The public IP address of the EC2 instance |
| instance_public_dns | The public DNS name of the EC2 instance |

## Examples

### Development Environment

```hcl
module "ec2_dev" {
  source = "./modules/ec2"

  environment   = "development"
  instance_type = "t2.micro"
}
```

### Production Environment

```hcl
module "ec2_prod" {
  source = "./modules/ec2"

  environment   = "production"
  instance_type = "t3.medium"
}
```

## Notes

- The module uses a random ID generator to create unique instance names
- The random ID is prefixed with the environment name
- The AMI is stored in the random ID keepers to ensure the instance is recreated when the AMI changes
- The instance is tagged with a name following the pattern: `app-server-{random_hex}`
- This module is configured for Localstack compatibility

## License

This module is part of the FoodTruck infrastructure project.
