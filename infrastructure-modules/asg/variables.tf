variable "env" {
  description = "Environment name  (e.g., dev, prod)"
  type = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type = string
}

variable "alb_sg_id" {
  description = "Security Group ID of the Application Load Balancer"
  type = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs"
  type = list(string)
}

variable "alb_target_group_arns" {
  description = "List of ALB Target Group ARNs"
  type = list(string)
}

variable "image_id" {
  description = "AMI ID for the EC2 instances"
  type = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type = string
}