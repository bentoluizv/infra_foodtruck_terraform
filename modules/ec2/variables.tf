variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "environment" {
  type = string
}

variable "ami_owner" {
  type = string
}

variable "subnet_id" {
  type = string
}
