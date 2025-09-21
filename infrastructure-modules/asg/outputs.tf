output "asg_name" {
  value       = aws_autoscaling_group.app_asg.name
  description = "Name of the ASG"
}

output "lt_id" {
  value       = aws_launch_template.app_lt.id
  description = "Launch Template ID"
}

output "asg_sg_id" {
  value       = aws_security_group.asg_sg.id
  description = "Security Group ID for ASG instances"
}