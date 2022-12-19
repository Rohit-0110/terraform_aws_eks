provider "aws" {
    region = "us-east-1"
    access_key = "AKIAS3ET7ZJHWPCIMXXI"
    secret_key = "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"
}

variable vpc_cidr_blocks {}
variable private_subnet_cidr_blocks {}
variable public_subnet_cidr_blocks {}

data "aws_availability_zones" "azs" {}

module "vpc" {
    source  = "terraform-aws-modules/vpc/aws"
    version = "3.18.1"

    name = "myapp-vpc"
    cidr = var.vpc_cidr_blocks
    private_subnets = var.private_subnet_cidr_blocks
    public_subnets = var.public_subnet_cidr_blocks
    azs = data.aws_availability_zones.azs.names

    enable_nat_gateway = true
    single_nat_gateway = true
    enable_dns_hostnames = true

    tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
    }

    public_subnet_tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        "kubernetes.io/role/elb" = 1
    }

    private_subnet_tags = {
        "kubernetes.io/cluster/myapp-eks-cluster" = "shared"
        "kubernetes.io/role/internal-elb" = 1
    }
}
