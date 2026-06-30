
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

locals {
  region = var.region

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)
  eks_cluster_name = "${var.name}-al2023"

  tags = {
    Example    = var.name
  }
}

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${var.name}-eks"
  cidr = "10.0.0.0/16"

  azs             = local.azs
  private_subnets     = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k)]
  public_subnets      = [for k, v in local.azs : cidrsubnet(local.vpc_cidr, 8, k + 4)]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  public_subnet_tags = {
    "kubernetes.io/role/elb"                          = "1"
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb"                 = "1"
    "kubernetes.io/cluster/${local.eks_cluster_name}" = "shared"
  }

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}