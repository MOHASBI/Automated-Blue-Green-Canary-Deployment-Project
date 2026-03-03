resource "aws_s3_bucket" "tf_state" {
  bucket = var.tf_state_bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "tf_state" {
  bucket = aws_s3_bucket.tf_state.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_dynamodb_table" "tf_lock" {
  name         = var.tf_lock_table_name
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket" "codedeploy_revisions" {
  bucket = var.codedeploy_revisions_bucket_name

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = ["sts.amazonaws.com"]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1",
    "1b511abead59c6cee45d44c9f3d8aa3b5ed9f5a3"
  ]

  tags = {
    Name = "github-oidc-provider"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_role" "github_actions" {
  name = "github-actions"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Federated = aws_iam_openid_connect_provider.github.arn }
        Action    = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          }
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_repo}:*"
          }
        }
      }
    ]
  })

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_iam_policy" "github_actions" {
  name        = "github-actions-policy"
  description = "Permissions for GitHub Actions CI/CD"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid    = "FullAccess"
        Effect = "Allow"
        Action = [
          "s3:*",
          "ecr:*",
          "ecs:*",
          "codedeploy:*",
          "dynamodb:*",
          "ec2:*",
          "elasticloadbalancing:*",
          "logs:*",
          "cloudwatch:*",
          "acm:*",
          "route53:*",
          "wafv2:*",
          "iam:*"
        ]
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "github_actions_attach" {
  role       = aws_iam_role.github_actions.name
  policy_arn = aws_iam_policy.github_actions.arn
}

resource "aws_ecr_repository" "app" {
  name                 = var.ecr_repository_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}




