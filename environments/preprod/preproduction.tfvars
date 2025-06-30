environment = "preprod"
region      = "eu-west-3"

vpc_cidr = "10.10.0.0/16"
public_subnet_cidrs = ["10.10.1.0/24", "10.10.2.0/24"]
private_subnet_cidrs = ["10.10.3.0/24", "10.10.4.0/24"]
azs = ["eu-west-3a", "eu-west-3b"]

instance_type     = "t3.small"
min_size          = 2
max_size          = 4
desired_capacity  = 2

db_username = "admin"
db_name     = "webappdb"

db_instance_class      = "db.t3.small"
allocated_storage      = 20
max_allocated_storage  = 100
multi_az               = true
deletion_protection    = true

# HTTPS/Domain configuration
# domain_name = "preprod.cloud-solutions.com"  
# create_route53_record = false        
# route53_zone_id = "ZONEID"           
# certificate_arn = "arn:aws:acm:eu-west-3:123456789012:certificate/preprod-cert-123"                