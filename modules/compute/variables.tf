variable "environment" {
  description = "Deployment environment"
  type        = string
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs"
  type        = list(string)
}

variable "web_security_group_id" {
  description = "Web security group ID"
  type        = string
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


variable "db_host" {
  description = "RDS database host address"
  type        = string
}

variable "db_port" {
  description = "RDS database port"
  type        = number
  default     = 3306  # Default MySQL port
}

variable "db_username" {
  description = "Database admin username"
  type        = string
  default     = "admin"
}

variable "db_password" {
  description = "Database admin password"
  type        = string
  default     = "password123"
}

variable "db_name" {
  description = "Database name"
  type        = string
  default     = "webappdb"
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name for EC2"
  type        = string
}

variable "log_group_name" {
  description = "CloudWatch log group name"
  type        = string
}