# Subnet group for RDS instances (defines which subnets RDS can use)
resource "aws_db_subnet_group" "main" {
  name       = "${var.environment}-db-subnet-group"
  subnet_ids = var.private_subnet_ids
  tags = {
    Name = "${var.environment}-db-subnet-group"
  }
}

# RDS MySQL database instance
resource "aws_db_instance" "main" {
  identifier             = "${var.environment}-db"
  engine                 = "mysql" # Database engine
  engine_version         = "5.7"
  instance_class         = var.db_instance_class
  allocated_storage      = var.allocated_storage
  max_allocated_storage  = var.max_allocated_storage
  storage_type           = "gp2"
  db_name                = var.db_name
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.main.name 
  vpc_security_group_ids = [var.db_security_group_id]
  multi_az               = var.multi_az # Enable Multi-AZ deployment
  skip_final_snapshot    = true # Don't create snapshot on deletion
  backup_retention_period = 7 # Retain backups for 7 days
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  deletion_protection    = var.deletion_protection
  apply_immediately      = true
  monitoring_role_arn    = var.rds_monitoring_role_arn # IAM role for monitoring
  monitoring_interval    = 60 # Monitoring interval in seconds

  tags = {
    Environment = var.environment
  }
}
