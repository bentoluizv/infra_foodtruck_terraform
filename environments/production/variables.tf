variable "instance_name" {
  type        = string
  description = "The name of the instance"
  default     = "app-server"
}

variable "environment" {
  type        = string
  description = "The environment"
  default     = "production"
}

variable "aws_region" {
  type        = string
  description = "The AWS region"
  default     = "sa-east-1"
}

variable "instance_type" {
  type        = string
  description = "The type of the instance"
  default     = "t2.micro"
}

variable "ami_owner" {
  type        = string
  description = "The owner of the AMI"
  default     = "099720109477"
}

variable "ubuntu_image_name" {
  type        = string
  description = "The name of the Ubuntu image"
  default     = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-20250516"
}
