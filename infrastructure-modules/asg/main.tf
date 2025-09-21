# Security Group for EC2 in ASG
resource "aws_security_group" "asg_sg" {
  name        = "${var.env}-asg-sg"
  description = "Allow inbound traffic from ALB"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id] # Allow traffic only from ALB SG
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# IAM Role + SSM Access
resource "aws_iam_role" "ssm_role" {
  name = "${var.env}-ssm-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy_attachment" "ssm_policy_attachment" {
  name       = "${var.env}-ssm-policy-attachment"
  roles      = [aws_iam_role.ssm_role.name]
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_instance_profile" {
  name = "${var.env}-ssm-instance-profile"
  role = aws_iam_role.ssm_role.name
}

# Launch Template for ASG
resource "aws_launch_template" "app_lt" {
  name_prefix   = "${var.env}-app-lt-"
  image_id      = var.image_id
  instance_type = var.instance_type

  vpc_security_group_ids = [aws_security_group.asg_sg.id]

  iam_instance_profile {
    name = aws_iam_instance_profile.ssm_instance_profile.name
  }

  user_data = filebase64("${path.module}/user_data.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "${var.env}-app"
      Env  = var.env
    }
  }
}

# Auto Scaling Group
resource "aws_autoscaling_group" "app_asg" {
  name                      = "${var.env}-app-asg"
  desired_capacity          = 2
  min_size                  = 1
  max_size                  = 3
  vpc_zone_identifier       = var.private_subnet_ids
  health_check_grace_period = 300
  health_check_type         = "ELB"

  launch_template {
    id      = aws_launch_template.app_lt.id
    version = "$Latest"
  }

  target_group_arns = var.alb_target_group_arns

  tag {
    key                 = "Name"
    value               = "${var.env}-app-instance"
    propagate_at_launch = true
  }
}

# Target Tracking Scaling Policy
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "${var.env}-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.app_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value     = 50.0
    disable_scale_in = false
  }
}