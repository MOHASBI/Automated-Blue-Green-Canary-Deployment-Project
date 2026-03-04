terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

//creates the alb
resource "aws_lb" "alb" {
  name               = "alb"
  internal           = false
  load_balancer_type = var.load_balancer_type
  security_groups    = [aws_security_group.alb.id]
  subnets            = var.public_subnets_id

  enable_deletion_protection = false

  tags = {
    Environment = "production"
  }
}



//creates the listener for https traffic to the alb
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = var.ssl_policy
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.blue_tg.arn
  }
}

//creates the listener for http traffic and redirects as https traffic to the alb
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

//creates alb's security group
resource "aws_security_group" "alb" {
  name   = "alb-sg"
  vpc_id = var.vpc_id

  ingress {
    description = "Allow https traffic from the browser to reach alb listener"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow http traffic from the browser to reach alb listener"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

//references the hosted zone of the domain
data "aws_route53_zone" "main" {
  name         = var.zone_name
  private_zone = false
}

//adjusts the A record in the hosted zone to reference the alb created
resource "aws_route53_record" "tm" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.record_name
  type    = var.record_type

  alias {
    name                   = aws_lb.alb.dns_name
    zone_id                = aws_lb.alb.zone_id
    evaluate_target_health = true
  }
}

//target groups green and blue for blue/green deployment
resource "aws_lb_target_group" "blue_tg" {
  name        = "blue-tg"
  port        = var.target_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = var.health_check_path
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = var.health_check_matcher
  }
}

resource "aws_lb_target_group" "green_tg" {
  name        = "green-tg"
  port        = var.target_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = var.health_check_path
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = var.health_check_matcher
  }
}


//WAF rules for the alb
resource "aws_wafv2_web_acl" "ALB_WAF" {
  name        = "ALB_WAF"
  description = "WAF rules for the ALB"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "aws_managed_rules_common_rule_set"
    priority = 1

    override_action {
      count {}
    }

    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"

      }
    }

    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "awsmanagedrulescommonruleset"
      sampled_requests_enabled   = true
    }
  }

  tags = {
    name = "ALB_WAF"
  }


  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "waf-rule-metric"
    sampled_requests_enabled   = true
  }
}

resource "aws_wafv2_web_acl_association" "alb" {
  resource_arn = aws_lb.alb.arn
  web_acl_arn  = aws_wafv2_web_acl.ALB_WAF.arn
}