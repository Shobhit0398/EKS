module "vpc" {

source="../../terraform-modules/modules/vpc"

cluster_name      = var.cluster_name
vpc_cidr          = var.vpc_cidr
availability_zones = var.availability_zones
public_subnets    = var.public_subnets
private_subnets   = var.private_subnets

}


module "eks" {

source="../../terraform-modules/modules/eks"

cluster_name    = var.cluster_name
vpc_id          = module.vpc.vpc_id
private_subnets = module.vpc.private_subnets

desired_size = var.desired_size
min_size     = var.min_size
max_size     = var.max_size

}   