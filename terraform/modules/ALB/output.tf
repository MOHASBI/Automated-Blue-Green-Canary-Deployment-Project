output "blue_target_group_arn" {
  value = aws_lb_target_group.blue_tg.arn
}

output "green_target_group_arn" {
  value = aws_lb_target_group.green_tg.arn
}

output "alb_arn" {
  value = aws_lb.alb.arn
}

output "alb_dns_name" {
  value = aws_lb.alb.dns_name
}

output "alb_zone_id" {
  value = aws_lb.alb.zone_id
}

output "alb_waf_arn" {
  value = aws_wafv2_web_acl.ALB_WAF.arn
}

output "alb_sg_id" {
  description = "ALB security group ID"
  value       = aws_security_group.alb.id
}

output "green_tg_name" {
  description = "Green target group name for CodeDeploy blue/green"
  value       = aws_lb_target_group.green_tg.name
}

output "blue_tg_name" {
  description = "Blue target group name for CodeDeploy blue/green"
  value       = aws_lb_target_group.blue_tg.name
}

output "https_listener_arn" {
  description = "HTTPS listener ARN (prod traffic route for CodeDeploy)"
  value       = aws_lb_listener.https.arn
}
