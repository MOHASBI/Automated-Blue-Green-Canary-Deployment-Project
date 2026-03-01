output "public_subnets_id" {
  description = "Public subnets ID"
  value = aws_subnet.public[*].id
}

output "private_subnets_id" {
  description = "Private subnets ID"
  value = aws_subnet.private[*].id
}

output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "igw_id" {
  description = "Internet gateway ID"
  value = aws_internet_gateway.igw.id
}

output "public_route_table_id" {
  description = "Public route table ID"
  value = aws_route_table.public.id
}

output "private_route_table_id" {
  description = "Private route table ID"
  value = aws_route_table.private.id
}       

output "ecr_endpoint_id" {
  description = "ECR endpoint ID"
  value = aws_vpc_endpoint.ecr.id
}

output "ecs_endpoint_id" {
  description = "ECS endpoint ID"
  value = aws_vpc_endpoint.ecs.id
}

output "logs_endpoint_id" {
  description = "Logs endpoint ID"
  value = aws_vpc_endpoint.logs.id
}

output "s3_endpoint_id" { 
  description = "S3 endpoint ID"
  value = aws_vpc_endpoint.s3.id
}

output "dynamodb_endpoint_id" {
  description = "DynamoDB endpoint ID"
  value       = aws_vpc_endpoint.DynamoDB.id
}

output "endpoints_sg_id" {
  description = "VPC endpoints security group ID"
  value       = aws_security_group.endpoints.id
}