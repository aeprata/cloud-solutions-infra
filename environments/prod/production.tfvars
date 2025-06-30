environment = "prod"
region      = "eu-west-3"

vpc_cidr = "10.20.0.0/16"
public_subnet_cidrs = ["10.20.1.0/24", "10.20.2.0/24"]
private_subnet_cidrs = ["10.20.3.0/24", "10.20.4.0/24"]
azs = ["eu-west-3a", "eu-west-3b"]

instance_type     = "t3.medium"
min_size          = 3
max_size          = 6
desired_capacity  = 3

db_username = "admin"
db_name     = "webappdb"

db_instance_class      = "db.m6g.large"
allocated_storage      = 100
max_allocated_storage  = 500
multi_az               = true
deletion_protection    = true

# HTTPS/Domain configuration
# domain_name = "cloud-solutions.com"  
# create_route53_record = false        
# route53_zone_id = "ZONEID"           
# certificate_arn = "arn:aws:acm:eu-west-3:123456789012:certificate/prod-cert-123"                