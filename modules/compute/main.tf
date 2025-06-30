# Fetch the latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  # Get the most recent image from Amazon
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }
}

# Launch template for web server EC2 instances
resource "aws_launch_template" "web" {
  name_prefix   = "${var.environment}-web-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true # Assign public IP
    security_groups             = [var.web_security_group_id] # Attach security group
  }

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.environment}-web-instance"
    }
  }

  iam_instance_profile {
    name = var.iam_instance_profile_name # Attach IAM role
  }

  # Pass user data script to instance
  user_data = base64encode(templatefile("${path.module}/user_data.sh", {
    db_host        = var.db_host
    db_port        = var.db_port
    db_username    = var.db_username
    db_password    = var.db_password
    db_name        = var.db_name
    log_group_name = var.log_group_name
  }))
}

# Auto Scaling Group for web servers
resource "aws_autoscaling_group" "web" {
  name                      = "${var.environment}-web-asg"
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  health_check_type         = "EC2" # Use EC2 health checks
  vpc_zone_identifier       = var.public_subnet_ids # Subnets for ASG
  default_cooldown          = 300
  health_check_grace_period = 300
  wait_for_capacity_timeout = "10m"

  launch_template {
    id      = aws_launch_template.web.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "${var.environment}-web-asg"
    propagate_at_launch = true
  }
}

# Scaling policy to add instances
resource "aws_autoscaling_policy" "scale_out" {
  name                   = "${var.environment}-scale-out"
  scaling_adjustment     = 1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300  # 5 minutes
  autoscaling_group_name = aws_autoscaling_group.web.name
}

# Scaling policy to remove instances
resource "aws_autoscaling_policy" "scale_in" {
  name                   = "${var.environment}-scale-in"
  scaling_adjustment     = -1
  adjustment_type        = "ChangeInCapacity"
  cooldown               = 300  # 5 minutes
  autoscaling_group_name = aws_autoscaling_group.web.name
}