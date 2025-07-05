variable "environment" {
  type    = string
  default = "production"
}

variable "vpc_cidr_block" {
  type        = string
  description = "The CIDR block for the VPC"
  default     = "10.0.0.0/28"
}

variable "public_subnet_cidr_block" {
  type        = string
  description = "The CIDR block for the public subnet"
  default     = "10.0.0.0/28"
}

variable "ami_owner" {
  type        = string
  description = "The owner of the AMI Canonical"
  default     = "099720109477"
}
