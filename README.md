# Automated Blue-Green Canary Deployment on AWS

Production-style platform build for a FastAPI URL shortener on AWS. The infrastructure is managed with Terraform and the delivery is keyless through GitHub OIDC. 
Releases use CodeDeploy blue green deployments to ECS Fargate behind an ALB that terminates TLS through ACM and is protected by WAF. 
The design keeps workloads private by using VPC endpoints and it avoids NAT to reduce cost. IAM access is least privilege so the blast radius stays small.

## Architecture

## Architecture

![High level architecture](images/architecturev2.gif)

### Network and edge components

![ALB resource map](images/ALB%20resource%20map.png)

![VPC endpoints](images/VPC%20Endpoints.png)

![WAF rule](images/WAF-Rule.png)

![WAF and ALB association](images/WAF-ALB%20association.png)

### GitHub OIDC trust setup

![OIDC trust policy](images/OIDC%20Trust%20Policy.png)


## Security and Guardrails

AWS WAF sits in front of the ALB and it uses managed rules to reduce exposure to common web attacks. The ALB terminates TLS using ACM managed certificates and it redirects HTTP traffic to HTTPS. GitHub Actions authenticates to AWS using OIDC so credentials are short lived and scoped through the role trust policy. IAM permissions are least privilege and they are scoped to the resources that the pipelines must manage. ECS tasks run in private subnets and the service only accepts inbound traffic from the ALB security group. Access to AWS services is routed through VPC endpoints so the platform avoids NAT and reduces egress cost.

## Getting Started

### Prerequisites

You need an AWS account that can create IAM and ECR and ECS and ALB and ACM and Route53 and DynamoDB and CodeDeploy resources. You also need a public domain and a Route53 hosted zone so ACM can complete DNS validation and so traffic can resolve to the ALB. You need Terraform version 1.6 or later and AWS CLI version 2 and Docker with Buildx and Git. You also need GitHub repository admin access so you can set secrets and run workflows.

You must define this GitHub repository secret before running pipelines:

- `AWS_ROLE_ARN` which points to the IAM role that trusts GitHub OIDC.

### Setup steps

1. Run bootstrap Terraform from `bootstrap/` one time so state storage and lock table and ECR and OIDC role exist.
2. Add bootstrap IAM role ARN to repository secret `AWS_ROLE_ARN`.
3. Run main infrastructure from `terraform/` so network and security and ECS and CodeDeploy resources are created.
   ```bash
   cd terraform
   terraform init -reconfigure
   terraform plan
   terraform apply
   ```
4. Push changes to `app/**` or run CI manually so the image builds and scans and pushes to ECR.
5. Run the deploy workflow so it registers a new task definition and starts blue green deployment through CodeDeploy.


