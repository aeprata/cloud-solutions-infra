variable "environment" {
  description = "Deployment environment (dev/stage/prod)"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for ALB placement"
  type        = list(string)
}

variable "web_security_group_id" {
  description = "Security group ID for web servers"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where resources will be created"
  type        = string
}

variable "asg_name" {
  description = "Name of the Auto Scaling Group to attach to the target group"
  type        = string
}

variable "alb_logs_bucket" {
  description = "S3 bucket for ALB access logs"
  type        = string
}

# Add these new variables
#variable "domain_name" {
#  description = "Application domain name"
#  type        = string
#}
#
#variable "certificate_arn" {
#  description = "ARN of existing ACM certificate"
#  type        = string
#  default     = ""
#}
#
#variable "create_route53_record" {
#  description = "Create Route53 record for ALB"
#  type        = bool
#  default     = false
#}
#
#variable "route53_zone_id" {
#  description = "Route53 hosted zone ID"
#  type        = string
#  default     = ""
#}