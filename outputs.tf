#output "application_url" {
#  description = "Application URL"
#  value       = module.loadbalancing.domain_name != "" ? "https://${module.loadbalancing.domain_name}" : "https://${module.loadbalancing.alb_dns_name}"
#}
#
#output "alb_dns_name" {
#  description = "ALB DNS name"
#  value       = module.loadbalancing.alb_dns_name
#}

