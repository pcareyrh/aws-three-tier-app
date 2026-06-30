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

variable "gh_token" {
  description = "GitHub token"
  type        = string
}