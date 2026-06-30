module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

#  repository_name = "${var.name}-ecr-private"
  repository_name = "tasky-app"
  repository_force_delete = true

  //repository_read_write_access_arns = ["arn:aws:iam::012345678901:role/terraform"]

  manage_registry_scanning_configuration = true
  registry_scan_type                     = "ENHANCED"
  registry_scan_rules = [
    {
      scan_frequency = "SCAN_ON_PUSH"
      filter = [
        {
          filter      = "tasky-app"
          filter_type = "WILDCARD"
        }
      ]
    }
  ]

  repository_read_write_access_arns = [aws_iam_role.github_oidc_role.arn]

  repository_lifecycle_policy = jsonencode({
    rules = [
      {
        rulePriority = 1,
        description  = "Keep last 30 images",
        selection = {
          tagStatus     = "tagged",
          tagPrefixList = ["v"],
          countType     = "imageCountMoreThan",
          countNumber   = 30
        },
        action = {
          type = "expire"
        }
      }
    ]
  })

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}