variable "account_backend_bucket" {
  description = "S3 bucket for Terraform state"
  type        = string
  default     = "tf-state-dev-s3"
}
variable "account_backend_key" {
  description = "S3 key for Terraform state"
  type        = string
  default     = "terraform.tfstate"
}
variable "account_backend_region" {
  description = "AWS region for Terraform state"
  type        = string
  default     = "eu-west-3" 
}

variable "environment" {
  description = "Environment (dev/stage/prod)"
  type        = string
  default     = "dev"
}

variable "region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-3" 
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"] 
}

variable "azs" {
  description = "Availability Zones"
  type        = list(string)
  default     = ["eu-west-3a", "eu-west-3b"]
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "SSH key pair name"
  type        = string
  default     = ""
}

variable "min_size" {
  description = "Minimum number of instances"
  type        = number
  default     = 2
}

variable "max_size" {
  description = "Maximum number of instances"
  type        = number
  default     = 4
}

variable "desired_capacity" {
  description = "Desired number of instances"
  type        = number
  default     = 2
}

variable "db_username" {
  description = "Database admin username"
  type        = string
  default     = "admin"
}


variable "db_name" {
  description = "Database name"
  type        = string
  default     = "webappdb"
}

variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro" 
}

variable "allocated_storage" {
  description = "Initial storage in GB"
  type        = number
  default     = 20
}

variable "max_allocated_storage" {
  description = "Maximum storage for autoscaling"
  type        = number
  default     = 100
}


variable "multi_az" {
  description = "Enable multi-AZ deployment"
  type        = bool
  default     = false
}

variable "deletion_protection" {
  description = "Protect from accidental deletion"
  type        = bool
  default     = true
}

#Add https configuration 

#variable "domain_name" {
#  description = "Application domain name"
#  type        = string
#}
#
#variable "certificate_arn" {
#  description = "ARN of existing ACM certificate (optional)"
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