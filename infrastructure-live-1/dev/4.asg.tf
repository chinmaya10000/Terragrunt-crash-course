# Security Group for EC2 in ASG
resource "aws_security_group" "asg_sg" {
  name        = "${local.env}-asg-sg"
  description = "Allow inbound traffic from ALB"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.alb_sg.id] # Only allow traffic from ALB
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Create ssm role for EC2 instances
resource "aws_iam_role" "ssm-role" {
  name = "${local.env}-ssm-role"

    assume_role_policy = jsonencode({
        Version = "2012-10-17"
        Statement = [{
            Effect = "Allow",
            Principal = {
                Service = "ec2.amazonaws.com"
            },
            Action = "sts:AssumeRole"
        }]
    })
}

# Attach AmazonSSMManagedInstanceCore policy to the role
resource "aws_iam_policy_attachment" "ssm_policy_attachment" {
  name       = "${local.env}-ssm-policy-attachment"
  roles      = [aws_iam_role.ssm-role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create Instance Profile for the role
resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${local.env}-ssm-instance-profile"
  role = aws_iam_role.ssm-role.name
}

# Launch Template for ASG
resource "aws_launch_template" "app-lt" {
  name_prefix   = "${local.env}-app-lt-"
  image_id      = local.image_id
  instance_type = local.instance_type

  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  # Attach IAM role (optional but recommended for SSM, CloudWatch, etc.)
  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }

  user_data = filebase64("${path.module}/user_data.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${local.env}-app"
      Env  = local.env
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app-asg" {
  name             = "${local.env}-app-asg"
  desired_capacity = 2
  max_size         = 3
  min_size         = 1

  vpc_zone_identifier       = [for s in aws_subnet.private : s.id]
  health_check_grace_period = 300
  health_check_type         = "ELB"

  launch_template {
    id      = aws_launch_template.app-lt.id 
    version = "$Latest"
  }

  target_group_arns = [
    aws_lb_target_group.api_tg.arn, 
    aws_lb_target_group.app_tg.arn
  ]

  tag {
    key                 = "Name"
    value               = "${local.env}-app-instance"
    propagate_at_launch = true
  }
}

# =======================================
# Target Tracking Scaling Policy
# =======================================
# 1. CPU Scaling Policy
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "${local.env}-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.app-asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0  # Keep average CPU around 50%
    disable_scale_in = false
  }
}

