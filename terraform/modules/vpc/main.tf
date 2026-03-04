terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
//create vpc
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_hostnames = true
  
  tags = {
    Name = "ecs_vpc"
  }
}

//create subnets for each AZ
resource "aws_subnet" "public"{
    count = length(var.public_subnet_cidrs)
    vpc_id = aws_vpc.main.id
    availability_zone = var.availability_zones[count.index]
    cidr_block = var.public_subnet_cidrs[count.index]
    
    tags = {
        Name = "public${count.index + 1}"
    }
}

//Create IGW
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "main"
  }
}

//Create route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "public_route"
  }
}

//associate the igw with the subnets
resource "aws_route_table_association" "a" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

//private subnets
resource "aws_subnet" "private" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "private${count.index + 1}"
  }
}


//create a gateway endpoint for s3 and dynamodb
resource "aws_vpc_endpoint" "s3" {
  vpc_id          = aws_vpc.main.id
  service_name    = "com.amazonaws.${var.region}.s3"
  route_table_ids = [aws_route_table.private.id]
  tags = {
    Environment = "s3-endpoint"
  }
}

resource "aws_vpc_endpoint" "DynamoDB" {
  vpc_id          = aws_vpc.main.id
  service_name    = "com.amazonaws.${var.region}.dynamodb"
  route_table_ids = [aws_route_table.private.id]
  
  tags = {
    Environment = "dynamodb-endpoint"
  }
}

//create a interface endpoint for every other service
resource "aws_vpc_endpoint" "ecr" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"

  subnet_ids = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.endpoints.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids  = [aws_security_group.endpoints.id]

  tags = {
    Name = "ecr-api-endpoint"
  }
}

resource "aws_vpc_endpoint" "ecs" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.ecs"
  vpc_endpoint_type = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.endpoints.id]
  private_dns_enabled = true
}

resource "aws_vpc_endpoint" "logs" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${var.region}.logs"
  vpc_endpoint_type = "Interface"
  subnet_ids          = aws_subnet.private[*].id
  security_group_ids = [aws_security_group.endpoints.id]
  private_dns_enabled = true
}

//route table for the private subnets
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "private-route-table"
  }
}

//private route table aws_route_table_association
resource "aws_route_table_association" "private_asso1" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

//create a security group for the endpoints
resource "aws_security_group" "endpoints" {
  name        = "endpoints-sg"
  description = "Security group for the endpoints"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "Allow https traffic from the browser to reach alb listener"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "endpoints-sg"
  }
}


 