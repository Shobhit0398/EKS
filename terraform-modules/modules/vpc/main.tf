
resource "aws_vpc" "this" {
    cidr_block = var.vpc_cidr

    tags = {
        Name = "${var.cluster_name}-vpc"
    }
}

resource "aws_internet_gateway" "igw" {
    vpc_id = aws_vpc.this.id
}

resource "aws_subnet" "public" {
    count = length(var.public_subnets)
    vpc_id = aws_vpc.this.id
    cidr_block = var.public_subnets[count.index]
    availability_zone = var.availability_zone[count.index]
    
    tags = {
        Name = "public-${count.index}"
    }
}

resource "aws_subnet" "private" {
    count = length(var.private_subnets)
    vpc_id = aws_vpc.this.id
    cidr_block = var.private_subnets[count.index]
    availability_zone = var.availability_zones[count.index]

    tags = {
        Name = "private-${count.index}"
    }
}

