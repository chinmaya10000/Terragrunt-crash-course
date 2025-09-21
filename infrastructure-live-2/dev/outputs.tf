# ========================
# VPC Outputs
# ========================
output "vpc_id" {
  description = "The ID of the VPC"
  value       = module.vpc.vpc_id
}

output "public_subnets" {
  description = "The IDs of the public subnets"
  value       = module.vpc.public_subnet_ids
}

output "private_subnets" {
  description = "The IDs of the private subnets"
  value       = module.vpc.private_subnet_ids
}

# ========================
# ALB Outputs
# ========================
output "alb_dns_name" {
  description = "DNS name of the ALB"
  value       = module.alb.alb_dns_name
}

output "alb_sg_id" {
  description = "Security group ID for ALB"
  value       = module.alb.alb_sg_id
}

output "api_tg_arn" {
  description = "ARN of the API Target Group"
  value       = module.alb.api_tg_arn
}

output "app_tg_arn" {
  description = "ARN of the APP Target Group"
  value       = module.alb.app_tg_arn
}

output "all_tg_arns" {
  description = "List of all Target Group ARNs"
  value       = module.alb.all_tg_arns
}

# ========================
# ASG Outputs
# ========================
output "asg_name" {
  value       = module.asg.asg_name
  description = "Name of ASG for dev"
}

output "launch_template_id" {
  value       = module.asg.lt_id
  description = "Launch Template ID for dev"
}

output "asg_sg_id" {
  value       = module.asg.asg_sg_id
  description = "Security Group ID for ASG instances (dev)"
}
