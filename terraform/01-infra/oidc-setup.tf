# Create OIDC Provider
/*module "iam_oidc_provider" {
  source = "terraform-aws-modules/iam/aws//modules/iam-oidc-provider"

  url = "https://token.actions.githubusercontent.com"
}
*/
resource "aws_iam_openid_connect_provider" "github" {
  url             = "https://token.actions.githubusercontent.com"
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = ["ffffffffffffffffffffffffffffffffffffffff"]
}

// Policy to use for actions. Restricted to our org + repo.
data "aws_iam_policy_document" "github_oidc_role" {
  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      values   = ["sts.amazonaws.com"]
      variable = "token.actions.githubusercontent.com:aud"
    }

    condition {
      test     = "StringLike"
      values   = ["repo:${var.github_org}/${var.github_repo}:*"]
      variable = "token.actions.githubusercontent.com:sub"
    }
  }
}

// create role for github oidc
resource "aws_iam_role" "github_oidc_role" {
  name               = "github_oidc_role"
  assume_role_policy = data.aws_iam_policy_document.github_oidc_role.json
}

// policy to allow ecr push
data "aws_iam_policy_document" "deploy" {
  statement {
    effect  = "Allow"
    actions = [
          "ecr:PutImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:DescribeImages",
          "ecr:ListImages"
    ]
    resources = ["arn:aws:ecr:${var.region}:${data.aws_caller_identity.current.account_id}:repository/${var.name}-ecr-private"]
  }
}

resource "aws_iam_policy" "deploy" {
  name        = "ci-deploy-policy"
  description = "Policy used for deployments on CI"
  policy      = data.aws_iam_policy_document.deploy.json
}

resource "aws_iam_role_policy_attachment" "attach-deploy" {
  role       = aws_iam_role.github_oidc_role.name
  policy_arn = aws_iam_policy.deploy.arn
}
