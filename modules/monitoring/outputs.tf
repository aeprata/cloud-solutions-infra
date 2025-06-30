output "alarm_arns" {
  description = "ARNs of all CloudWatch alarms"
  value = [
    aws_cloudwatch_metric_alarm.high_cpu.arn,
    aws_cloudwatch_metric_alarm.db_high_connections.arn,
    aws_cloudwatch_metric_alarm.alb_5xx_errors.arn
  ]
}