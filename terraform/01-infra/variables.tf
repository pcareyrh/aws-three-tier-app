variable "name" {
  description = "The name for resources"
}

variable "kubernetes_version" {
  description = "The version for eks"
}

variable "region" {
  description = "AWS region"
  type        = string
}

variable "mongo_uri" {
  description = "Mongodb URI"
  type        = string
}

variable "github_org" {
  description = "GitHub organization"
  type        = string
}

variable "github_repo" {
  description = "GitHub repository"
  type        = string
}

variable "github_token" {
  description = "GitHub token"
  type        = string
  default     = null
}

variable "github_environment" {
  description = "GitHub Actions environment name for optional secret management"
  type        = string
  default     = "dev"
}