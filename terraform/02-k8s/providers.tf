terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.20"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.10"
    }
  }
}

provider "aws" {
  region = var.region
}

provider "kubernetes" {
  host                   = data.tfe_outputs.terraform_workspace.outputs["eks_cluster_endpoint"].value
  cluster_ca_certificate = base64decode(data.tfe_outputs.terraform_workspace.outputs["eks_cluster_certificate_authority_data"].value)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", data.tfe_outputs.terraform_workspace.outputs["eks_cluster_name"].value, "--region", var.region]
  }
}

provider "helm" {
  kubernetes {
    host                   = data.tfe_outputs.terraform_workspace.outputs["eks_cluster_endpoint"].value
    cluster_ca_certificate = base64decode(data.tfe_outputs.terraform_workspace.outputs["eks_cluster_certificate_authority_data"].value)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", data.tfe_outputs.terraform_workspace.outputs["eks_cluster_name"].value, "--region", var.region]
    }
  }
}