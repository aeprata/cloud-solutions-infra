output "vpc_id" {
  description = "VPC ID"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = aws_subnet.public[*].id
}
output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = aws_subnet.private[*].id
}
output "web_security_group_id" {
  description = "Web Security Group ID"
  value       = aws_security_group.web.id 
}

output "db_security_group_id" {
  description = "Database Security Group ID"
  value       = aws_security_group.db.id   
}