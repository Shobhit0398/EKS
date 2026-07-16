variable "vpc_cidr" {
    default = "10.0.0.0/16"
}

variable "public_subnets" {
    type = list(string)
}

variable "private_subnets" {

  type = list(string)

}

variable "availability_zones" {

  type = list(string)

}

variable "cluster_name" {}

