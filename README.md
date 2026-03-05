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


