variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "asg_name" {
  description = "Auto Scaling Group name"
  type        = string
}

variable "db_identifier" {
  description = "RDS instance identifier"
  type        = string
}

variable "alb_arn_suffix" {
  description = "ALB ARN suffix"
  type        = string
}
variable "scale_out_policy_arn" {
  description = "ARN of scale-out policy"
  type        = string
}

variable "scale_in_policy_arn" {
  description = "ARN of scale-in policy"
  type        = string
}

variable "waf_acl_name" {
  description = "WAF Web ACL name"
  type        = string
}