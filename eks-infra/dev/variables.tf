variable "aws_region" {}

variable "cluster_name" {}

variable "vpc_cidr" {}

variable "availability_zones" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "desired_size" {
  type = number
}

variable "min_size" {
  type = number
}

variable "max_size" {
  type = number
}

