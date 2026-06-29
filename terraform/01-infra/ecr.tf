module "ecr" {
  source = "terraform-aws-modules/ecr/aws"

  repository_name = "${var.name}-ecr-private"

  //repository_read_write_access_arns = ["arn:aws:iam::012345678901:role/terraform"]

/* add later
  image_scanning_configuration {
    scan_on_push = true
  }

  encryption_configuration {
    encryption_type = "AES256"
  }
*/

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