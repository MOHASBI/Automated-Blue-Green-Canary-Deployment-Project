terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

//creates the trust policy for the iam role
data "aws_iam_policy_document" "assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = var.task_service_principals
    }
  }
}

//creates the execution role
resource "aws_iam_role" "ecs_execution_role" {
  name               = var.ecs_execution_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

//attaches the permission to the iam
resource "aws_iam_role_policy_attachment" "ecs_exec_permissions" {
  role       = aws_iam_role.ecs_execution_role.name
  policy_arn = var.ecs_execution_policy_arn
}

// creates the task role used by the running ECS task
resource "aws_iam_role" "ecs_task_role" {
  name               = var.ecs_task_role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

// inline policy granting least-privilege access to the DynamoDB table
data "aws_iam_policy_document" "ecs_task_dynamodb" {
  statement {
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
    ]

    resources = [
      var.dynamodb_table_arn,
    ]
  }
}

//DynamoDB iam roles
resource "aws_iam_role_policy" "ecs_task_dynamodb" {
  name   = "${var.ecs_task_role_name}-dynamodb"
  role   = aws_iam_role.ecs_task_role.id
  policy = data.aws_iam_policy_document.ecs_task_dynamodb.json
}

//iam role declaration for codedeploy
data "aws_iam_policy_document" "codedeploy_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "codedeploy_role" {
  name               = var.codedeploy_role_name
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role.json
}

resource "aws_iam_role_policy_attachment" "codedeploy_managed" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}


