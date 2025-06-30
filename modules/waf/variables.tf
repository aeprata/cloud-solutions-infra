# modules/waf/variables.tf
variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "alb_arn" {
  description = "ARN of the ALB to protect"
  type        = string
}