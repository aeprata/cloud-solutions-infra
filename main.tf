terraform {
  backend "s3" {
    bucket         = ""
    key            = ""
    region         = ""
  }
}

# Fetch the latest version of the database password from AWS Secrets Manager
data "aws_secretsmanager_secret_version" "db_password" {
  secret_id = "${var.environment}/database/password"
}


module "waf" {
  source      = "./modules/waf"
  environment = var.environment
  alb_arn     = module.loadbalancing.alb_arn
}
module "networking" {
  source               = "./modules/networking"
  environment          = var.environment
  vpc_cidr             = var.vpc_cidr
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  azs                  = var.azs
}

module "iam" {
  source      = "./modules/iam"
  environment = var.environment
  alb_logs_bucket = module.logging.alb_logs_bucket
}

module "logging" {
  source      = "./modules/logging"
  environment = var.environment
}

module "storage" {
  source                  = "./modules/storage"
  environment             = var.environment
  private_subnet_ids      = module.networking.private_subnet_ids
  db_security_group_id    = module.networking.db_security_group_id
  db_username             = var.db_username
  db_password             = data.aws_secretsmanager_secret_version.db_password.secret_string
  db_name                 = var.db_name
  rds_monitoring_role_arn = module.iam.rds_monitoring_role_arn
}

module "compute" {
  source                    = "./modules/compute"
  environment               = var.environment
  public_subnet_ids         = module.networking.public_subnet_ids
  web_security_group_id     = module.networking.web_security_group_id
  instance_type             = var.instance_type
  key_name                  = var.key_name
  min_size                  = var.min_size
  max_size                  = var.max_size
  desired_capacity          = var.desired_capacity
  db_host                   = module.storage.db_host  
  db_port                   = module.storage.db_port
  db_username               = var.db_username
  db_password               = data.aws_secretsmanager_secret_version.db_password.secret_string
  db_name                   = var.db_name
  iam_instance_profile_name = module.iam.ec2_instance_profile_name
  log_group_name            = module.logging.app_log_group_name
}

module "loadbalancing" {
  source                = "./modules/loadbalancing"
  environment           = var.environment
  public_subnet_ids     = module.networking.public_subnet_ids
  web_security_group_id = module.networking.web_security_group_id
  vpc_id                = module.networking.vpc_id
  asg_name              = module.compute.asg_name
  alb_logs_bucket       = module.logging.alb_logs_bucket
#  domain_name           = var.domain_name      
#  certificate_arn       = var.certificate_arn      
#  create_route53_record = var.create_route53_record      
#  route53_zone_id       = var.route53_zone_id      
}

module "monitoring" {
  source               = "./modules/monitoring"
  environment          = var.environment
  asg_name             = module.compute.asg_name
  db_identifier        = module.storage.db_identifier
  alb_arn_suffix       = module.loadbalancing.alb_arn_suffix
  scale_out_policy_arn = module.compute.scale_out_policy_arn
  scale_in_policy_arn  = module.compute.scale_in_policy_arn
  waf_acl_name    = "${var.environment}-web-acl"
}
