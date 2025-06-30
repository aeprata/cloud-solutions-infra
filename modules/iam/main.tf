# IAM role for EC2 instances to allow SSM and CloudWatch access
resource "aws_iam_role" "ec2_instance_role" {
  name = "${var.environment}-ec2-role"

  # Trust policy for EC2 to assume this role
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

# Attach SSM core policy to EC2 role (for Systems Manager)
resource "aws_iam_role_policy_attachment" "ssm_core" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Attach CloudWatch agent policy to EC2 role (for logging/monitoring)
resource "aws_iam_role_policy_attachment" "cloudwatch_agent" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

# Policy to allow EC2 to access Secrets Manager for DB credentials
resource "aws_iam_role_policy" "secrets_manager_access" {
  name = "${var.environment}-secrets-manager-policy"
  role = aws_iam_role.ec2_instance_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = "secretsmanager:GetSecretValue"
        Resource = "arn:aws:secretsmanager:*:*:secret:${var.environment}/database/password*"
      },
      {
        Effect    = "Allow"
        Action    = "secretsmanager:ListSecrets"
        Resource  = "*"
      }
    ]
  })
}

# Instance profile for EC2 to use the above role
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.environment}-ec2-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}

# IAM role for RDS Enhanced Monitoring
resource "aws_iam_role" "rds_monitoring_role" {
  name = "${var.environment}-rds-monitoring-role"

  # Trust policy for RDS monitoring service
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "monitoring.rds.amazonaws.com"
        }
      }
    ]
  })
}

# Attach RDS Enhanced Monitoring policy to RDS role
resource "aws_iam_role_policy_attachment" "rds_enhanced_monitoring" {
  role       = aws_iam_role.rds_monitoring_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonRDSEnhancedMonitoringRole"
}

# Policy for EC2 role to allow ALB access to S3 for logging
resource "aws_iam_role_policy" "alb_logging" {
  name = "${var.environment}-alb-logging-policy"
  role = aws_iam_role.ec2_instance_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:PutObject",
          "s3:PutObjectAcl"
        ]
        Resource = ["arn:aws:s3:::${var.alb_logs_bucket}/*"]
      },
      {
        Effect = "Allow"
        Action = "s3:ListBucket"
        Resource = "arn:aws:s3:::${var.alb_logs_bucket}"
      }
    ]
  })
}

# Policy for EC2 role to allow Auto Scaling actions
resource "aws_iam_role_policy" "autoscaling" {
  name = "${var.environment}-autoscaling-policy"
  role = aws_iam_role.ec2_instance_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "autoscaling:DescribeAutoScalingGroups",
          "autoscaling:DescribeAutoScalingInstances",
          "autoscaling:SetDesiredCapacity",
          "autoscaling:TerminateInstanceInAutoScalingGroup"
        ]
        Resource = "*"
      }
    ]
  })
}