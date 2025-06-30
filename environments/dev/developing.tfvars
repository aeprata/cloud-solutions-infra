environment = "dev"
region      = "eu-west-3"

vpc_cidr = "10.0.0.0/16"
public_subnet_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
private_subnet_cidrs = ["10.0.3.0/24", "10.0.4.0/24"]
azs = ["eu-west-3a", "eu-west-3b"]

instance_type     = "t3.micro"
min_size          = 2
max_size          = 4
desired_capacity  = 2

# Database configuration
db_username = "admin"
db_name     = "webappdb"

# Storage configuration (RDS)
db_instance_class      = "db.t3.micro"
allocated_storage      = 20
max_allocated_storage  = 100
multi_az               = false
deletion_protection    = true

# HTTPS/Domain configuration
# domain_name = "dev.cloud-solutions.com"  
# create_route53_record = false        
# route53_zone_id = "ZONEID"           
# certificate_arn = "arn:aws:acm:eu-west-3:123456789012:certificate/dev-cert-123"                