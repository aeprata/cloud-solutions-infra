# CloudWatch Alarms

# CloudWatch Alarm for high average CPU utilization
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
  alarm_name          = "${var.environment}-high-cpu"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "Average CPU utilization over 80%"
  treat_missing_data  = "ignore"
  
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

# CloudWatch Alarm for high number of DB connections
resource "aws_cloudwatch_metric_alarm" "db_high_connections" {
  alarm_name          = "${var.environment}-db-high-connections"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "DatabaseConnections"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 50
  alarm_description   = "Database connections over 50"
  treat_missing_data  = "ignore"
  
  dimensions = {
    DBInstanceIdentifier = var.db_identifier
  }
}

# CloudWatch Alarm for ALB 5XX errors
resource "aws_cloudwatch_metric_alarm" "alb_5xx_errors" {
  alarm_name          = "${var.environment}-alb-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "HTTPCode_Target_5XX_Count"
  namespace           = "AWS/ApplicationELB"
  period              = 60
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "More than 10 5XX errors in 1 minute"
  treat_missing_data  = "ignore"
  
  dimensions = {
    LoadBalancer = var.alb_arn_suffix
  }
}

# CloudWatch Alarm to trigger scale-out when CPU is high
resource "aws_cloudwatch_metric_alarm" "high_cpu_scale" {
  alarm_name          = "${var.environment}-high-cpu-scale"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120  # 2 minutes
  statistic           = "Average"
  threshold           = 70  # Trigger if CPU > 70%
  alarm_description   = "Scale out when CPU > 70% for 4 minutes"
  alarm_actions       = [var.scale_out_policy_arn]
  treat_missing_data  = "ignore"
  
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

# CloudWatch Alarm to trigger scale-in when CPU is low
resource "aws_cloudwatch_metric_alarm" "low_cpu_scale" {
  alarm_name          = "${var.environment}-low-cpu-scale"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120  # 2 minutes
  statistic           = "Average"
  threshold           = 30  # Trigger if CPU < 30%
  alarm_description   = "Scale in when CPU < 30% for 6 minutes"
  alarm_actions       = [var.scale_in_policy_arn]
  treat_missing_data  = "ignore"
  
  dimensions = {
    AutoScalingGroupName = var.asg_name
  }
}

# CloudWatch Alarm for WAF blocked requests
resource "aws_cloudwatch_metric_alarm" "waf_blocked_requests" {
  alarm_name          = "${var.environment}-waf-blocked-requests"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 1
  metric_name         = "BlockedRequests"
  namespace           = "AWS/WAFV2"
  period              = 300
  statistic           = "Sum"
  threshold           = 10
  alarm_description   = "More than 10 blocked requests in 5 minutes"
  
  dimensions = {
    WebACL = var.waf_acl_name
    Rule   = "ALL"
  }
}