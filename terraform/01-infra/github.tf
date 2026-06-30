resource "github_actions_environment_secret" "eks_cluster_name" {
  repository  = var.github_repo
  environment = var.github_environment
  secret_name = "EKS_CLUSTER_NAME"
  value       = module.eks.cluster_name
}

resource "github_actions_environment_secret" "mongodb_user" {
  repository  = var.github_repo
  environment = var.github_environment
  secret_name = "MONGODB_USER"
  value       = "tasky"
}


resource "random_string" "mongodb_password_random" {
  length  = 10
  upper   = false
  special = false
}

resource "github_actions_environment_secret" "mongodb_password" {
  repository  = var.github_repo
  environment = var.github_environment
  secret_name = "MONGODB_PASSWORD"
  value       = random_string.mongodb_password_random.result
}