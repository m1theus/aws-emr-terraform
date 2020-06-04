variable "region" {
  default = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR Block for VPC"
  default = "10.0.2.0/24"
}

variable "public_subnet_cidr" {
  description = "CIDR Block for Public Subnet 1"
  default = "10.0.2.0/24"
}

