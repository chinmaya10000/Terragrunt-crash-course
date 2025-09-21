output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = aws_lb.app_alb.dns_name
}

output "alb_sg_id" {
  description = "Security group ID for ALB"
  value       = aws_security_group.alb_sg.id
}

output "api_tg_arn" {
  description = "ARN of the API Target Group"
  value       = aws_lb_target_group.api_tg.arn
}

output "app_tg_arn" {
  description = "ARN of the APP Target Group"
  value       = aws_lb_target_group.app_tg.arn
}

output "all_tg_arns" {
  description = "List of all Target Group ARNs"
  value       = [
    aws_lb_target_group.api_tg.arn,
    aws_lb_target_group.app_tg.arn
  ]
}
