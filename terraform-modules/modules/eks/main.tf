data "aws_iam_policy_document" "cluster_assume_role" {

  statement {

    actions = ["sts:AssumeRole"]

    principals {

      type = "Service"

      identifiers = ["eks.amazonaws.com"]

    }

  }

}

resource "aws_iam_role" "cluster_role" {

  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = data.aws_iam_policy_document.cluster_assume_role.json

}

resource "aws_iam_role_policy_attachment" "cluster_policy" {

  role = aws_iam_role.cluster_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"

}

data "aws_iam_policy_document" "node_assume_role" {

  statement {

    actions = ["sts:AssumeRole"]

    principals {

      type = "Service"

      identifiers = [

        "ec2.amazonaws.com"

      ]

    }

  }

}

resource "aws_iam_role" "node_role" {

  name = "${var.cluster_name}-node-role"

  assume_role_policy = data.aws_iam_policy_document.node_assume_role.json

}

resource "aws_iam_role_policy_attachment" "worker1" {

  role = aws_iam_role.node_role.name

  policy_arn="arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"

}

resource "aws_iam_role_policy_attachment" "worker2" {

  role = aws_iam_role.node_role.name

  policy_arn="arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"

}
resource "aws_iam_role_policy_attachment" "worker3" {

  role = aws_iam_role.node_role.name

  policy_arn="arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"

}

resource "aws_security_group" "eks" {

  name="${var.cluster_name}-sg"

  description="EKS Cluster SG"

  vpc_id=var.vpc_id

}
resource "aws_vpc_security_group_ingress_rule" "https" {

  security_group_id = aws_security_group.eks.id

  cidr_ipv4 = "0.0.0.0/0"

  from_port = 443

  to_port = 443

  ip_protocol = "tcp"

}

resource "aws_vpc_security_group_egress_rule" "all" {

  security_group_id = aws_security_group.eks.id

  cidr_ipv4="0.0.0.0/0"

  ip_protocol="-1"

}


resource "aws_eks_cluster" "cluster" {

  name = var.cluster_name

  role_arn = aws_iam_role.cluster_role.arn

  version = "1.31"

  vpc_config {

    subnet_ids = var.private_subnets

    security_group_ids = [

      aws_security_group.eks.id

    ]

  }

  depends_on = [

    aws_iam_role_policy_attachment.cluster_policy

  ]

}

resource "aws_eks_node_group" "workers" {

  cluster_name = aws_eks_cluster.cluster.name

  node_group_name="workers"

  node_role_arn=aws_iam_role.node_role.arn

  subnet_ids=var.private_subnets

  scaling_config {

    desired_size = var.desired_size

    min_size = var.min_size

    max_size = var.max_size
  }

  ami_type="AL2023_x86_64_STANDARD"

  instance_types=[

    "t3.medium"

  ]
  disk_size=30
  
}
