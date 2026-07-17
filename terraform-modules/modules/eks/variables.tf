variable "cluster_name" {}

variable "private_subnets" {

 type=list(string)

}

variable "vpc_id" {}

variable "desired_size" {}

variable "min_size" {}

variable "max_size" {}

variable "ami_type" {}

variable "disk_size" {}