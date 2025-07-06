variable "instance_name" {
  type        = string
  description = "The name of the instance"
  default     = "app-server"
}

variable "environment" {
  type        = string
  description = "The environment"
  default     = "local"
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
  default     = "000000000000"
}

variable "ubuntu_image_name" {
  type        = string
  description = "The name of the Ubuntu image"
  default     = "ubuntu-22.04-jammy-jellyfish"
}
