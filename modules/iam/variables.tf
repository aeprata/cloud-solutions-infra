# modules/iam/variables.tf
variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "alb_logs_bucket" {
  description = "S3 bucket for ALB access logs"
  type        = string
}