# S3 Module

This Terraform module creates an AWS S3 bucket with basic configuration and tagging.

## Overview

The S3 module provides a simple way to provision AWS S3 buckets with consistent naming and tagging conventions. It creates a basic S3 bucket resource with environment-specific tags.

## Features

- Creates an AWS S3 bucket with a specified name
- Applies consistent tagging (Name and Environment)
- Simple and reusable module design

## Usage

```hcl
module "s3_bucket" {
  source = "../../modules/s3"

  bucket_name = "my-application-bucket"
  environment = "production"
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| aws | >= 4.0 |

## Providers

| Name | Version |
|------|---------|
| aws | >= 4.0 |

## Inputs

| Name | Description | Type | Required |
|------|-------------|------|----------|
| bucket_name | The name of the S3 bucket to create | `string` | Yes |
| environment | The environment name (e.g., development, staging, production) | `string` | Yes |

## Outputs

This module currently doesn't define any outputs. The S3 bucket resource is created but not exposed as an output.

## Resources Created

- `aws_s3_bucket.bucket` - The main S3 bucket resource

## Tags

The following tags are automatically applied to the S3 bucket:

- `Name` - Set to the bucket name
- `Environment` - Set to the environment variable value

## Example

### Basic Usage

```hcl
module "data_bucket" {
  source = "../../modules/s3"

  bucket_name = "foodtruck-data-storage"
  environment = "production"
}
```

### Multiple Buckets

```hcl
module "logs_bucket" {
  source = "../../modules/s3"

  bucket_name = "foodtruck-logs"
  environment = "production"
}

module "backup_bucket" {
  source = "../../modules/s3"

  bucket_name = "foodtruck-backups"
  environment = "production"
}
```

## Notes

- This module creates a basic S3 bucket without additional configurations like versioning, encryption, or lifecycle policies
- Consider extending this module or using additional resources if you need advanced S3 features
- Ensure bucket names are globally unique across all AWS accounts
- Follow AWS S3 naming conventions (lowercase, no underscores, 3-63 characters)

## Contributing

When contributing to this module:

1. Ensure all variables are properly documented
2. Add appropriate outputs if needed
3. Update this README with any new features or changes
4. Test the module in different environments
