# Application Load Balancer for web traffic
resource "aws_lb" "web" {
  name               = "${var.environment}-web-alb"
  internal           = false # Public ALB
  load_balancer_type = "application"
  security_groups    = [var.web_security_group_id] # Attach security group
  subnets            = var.public_subnet_ids # Public subnets
  
  enable_deletion_protection = false

  access_logs {
    bucket  = var.alb_logs_bucket # S3 bucket for ALB logs
    enabled = true
    prefix  = "alb-logs"
  }

  tags = {
    Environment = var.environment
  }
}

# Target group for web servers
resource "aws_lb_target_group" "web" {
  name     = "${var.environment}-web-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/" # Health check path
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }
}

# HTTP listener for ALB
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web.arn
  }
}

# Attach Auto Scaling Group to ALB target group
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = var.asg_name
  lb_target_group_arn    = aws_lb_target_group.web.arn
}



# HTTPS Listener and Certificate configuration (optional)
#resource "aws_lb_listener" "https" {
#  load_balancer_arn = aws_lb.web.arn
#  port              = 443
#  protocol          = "HTTPS"
#  ssl_policy        = "ELBSecurityPolicy-2016-08"
#  certificate_arn   = coalesce(var.certificate_arn, aws_acm_certificate.web[0].arn)
#
#  default_action {
#    type             = "forward"
#    target_group_arn = aws_lb_target_group.web.arn
#  }
#}
#
## HTTP to HTTPS Redirect
#resource "aws_lb_listener" "http" {
#  load_balancer_arn = aws_lb.web.arn
#  port              = 80
#  protocol          = "HTTP"
#
#  default_action {
#    type = "redirect"
#
#    redirect {
#      port        = "443"
#      protocol    = "HTTPS"
#      status_code = "HTTP_301"
#    }
#  }
#}
#
## ACM Certificate
#resource "aws_acm_certificate" "web" {
#  count = var.certificate_arn == "" ? 1 : 0
#
#  domain_name       = var.domain_name
#  validation_method = "DNS"
#
#  lifecycle {
#    create_before_destroy = true
#  }
#}
#
## Route53 Record
#resource "aws_route53_record" "web" {
#  count = var.create_route53_record ? 1 : 0
#
#  zone_id = var.route53_zone_id
#  name    = var.domain_name
#  type    = "A"
#
#  alias {
#    name                   = aws_lb.web.dns_name
#    zone_id                = aws_lb.web.zone_id
#    evaluate_target_health = true
#  }
#}