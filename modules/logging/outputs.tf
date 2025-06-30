output "app_log_group_name" {
  description = "CloudWatch Log Group name for application logs"
  value       = aws_cloudwatch_log_group.app_logs.name
}

output "alb_logs_bucket" {
  description = "S3 bucket for ALB access logs"
  value       = aws_s3_bucket.alb_logs.id
}