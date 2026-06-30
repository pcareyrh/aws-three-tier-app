module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.name}-al2023"
  kubernetes_version = "1.33"

  # EKS Addons
  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  enabled_log_types = [
      "api",
      "audit",
      "authenticator",
      "controllerManager",
      "scheduler"
    ]

  # Optional: control the CloudWatch log group directly
  create_cloudwatch_log_group            = true
  cloudwatch_log_group_retention_in_days = 7

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  # Testing Access
  endpoint_public_access  = true
  enable_cluster_creator_admin_permissions = true

  eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      instance_types = ["t3.medium"]
      ami_type       = "AL2023_x86_64_STANDARD"

      min_size = 2
      max_size = 5
      # This value is ignored after the initial creation
      # https://github.com/bryantbiggs/eks-desired-size-hack
      desired_size = 2

    }
  }
}

resource "github_actions_environment_secret" "eks_cluster_name" {
  count       = var.manage_github_environment_secret ? 1 : 0
  repository  = var.github_repo
  environment = var.github_environment
  secret_name = "EKS_CLUSTER_NAME"
  value       = module.eks.cluster_name
}

/*
resource "null_resource" "kubeconfig" {

  provisioner "local-exec" {
    command = "aws eks --region ${var.region} update-kubeconfig --name ${module.eks.cluster_name}"
  }

  depends_on = [
    module.eks
  ]
}
*/
/*module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name               = "${var.name}-eks"
  kubernetes_version = var.kubernetes_version

  # Optional
  endpoint_public_access = true

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  compute_config = {
    enabled    = true
    node_pools = ["general-purpose"]
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  cluster_addons = {
    eks-pod-identity-agent = {}
  }

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}
// remove this lateer.
/*
module "eks_auto_custom_node_pools" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  name                   = "${var.name}-custom"
  kubernetes_version     = var.kubernetes_version
  endpoint_public_access = true

  enable_cluster_creator_admin_permissions = true

  # Create just the IAM resources for EKS Auto Mode for use with custom node pools
  create_auto_mode_iam_resources = true
  compute_config = {
    enabled = true
  }

  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnets

  tags = local.tags
}*/
