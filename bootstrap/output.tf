output "tf_state_bucket_name" {
  value = aws_s3_bucket.tf_state.bucket
}

output "tf_lock_table_name" {
  value = aws_dynamodb_table.tf_lock.name
}

output "codedeploy_revisions_bucket_name" {
  value = aws_s3_bucket.codedeploy_revisions.bucket
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions.arn
}

output "oidc_provider_arn" {
  value = aws_iam_openid_connect_provider.github.arn
}

output "ecr_repository_arn" {
  value = aws_ecr_repository.app.arn
}

output "ecr_repository_url" {
  value = aws_ecr_repository.app.repository_url
}
