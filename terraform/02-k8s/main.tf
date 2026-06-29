
data "aws_availability_zones" "available" {}
data "aws_caller_identity" "current" {}

data "tfe_outputs" "terraform_workspace" {
  workspace = "aws-three-tier-app"
  organization = "pcarey-org"
}

locals {
  region = var.region

  vpc_cidr = "10.0.0.0/16"
  azs      = slice(data.aws_availability_zones.available.names, 0, 3)

  tags = {
    Example    = var.name
  }
}
