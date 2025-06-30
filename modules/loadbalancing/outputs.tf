output "alb_dns_name" {
  value = aws_lb.web.dns_name
}

output "alb_arn_suffix" {
  value = aws_lb.web.arn_suffix
}

output "alb_arn" {
  value = aws_lb.web.arn
}

# output "alb_dns_name" {
#   value = aws_lb.web.dns_name
# }
# 
# output "alb_arn_suffix" {
#   value = aws_lb.web.arn_suffix
# }
# 
# output "domain_name" {
#   value = var.create_route53_record ? aws_route53_record.web[0].fqdn : ""
# }