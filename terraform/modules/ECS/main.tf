//creates the ecs cluster
resource "aws_ecs_cluster" "ecs" {
  name = var.cluster_name
}

//creates the cloudwatch log group
resource "aws_cloudwatch_log_group" "ecs" {
  name              = var.log_group_name
  retention_in_days = var.log_retention_in_days
}

//creates the task definition
resource "aws_ecs_task_definition" "task_definition" {
  family                   = var.task_family
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu             = var.task_cpu
  memory          = var.task_memory
  execution_role_arn = var.ecs_task_execution_role_arn
  task_role_arn      = var.ecs_task_role_arn

  container_definitions = jsonencode([
    {
      name      = var.container_name
      image     = "${var.ecr_repo_url}:${var.image_tag}"
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = var.container_port
          protocol      = var.container_protocol
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = var.awslogs_stream_prefix
        }
      }
    }
  ])

  runtime_platform {
    operating_system_family = var.operating_system_family
    cpu_architecture        = var.cpu_architecture
  }
}

//creates the security group for the ecs tasks
resource "aws_security_group" "ecs_tasks" {
  name   = "ecs-tasks-sg"
  vpc_id = var.vpc_id

  ingress {
    description     = "Allow ALB to reach ECS tasks on application port"
    from_port       = var.container_port
    to_port         = var.container_port
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//creates the service
resource "aws_ecs_service" "service" {
  name                          = var.service_name
  cluster                       = aws_ecs_cluster.ecs.id
  task_definition               = aws_ecs_task_definition.task_definition.arn
  launch_type                   = var.launch_type
  platform_version              = var.platform_version
  desired_count                 = var.desired_count
  availability_zone_rebalancing = var.availability_zone_rebalancing

  deployment_controller {
    type = var.deployment_controller_type
  }

  network_configuration {
    subnets          = var.private_subnets_id
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.target_group_arn
    container_name   = var.container_name
    container_port   = var.container_port
  }
}