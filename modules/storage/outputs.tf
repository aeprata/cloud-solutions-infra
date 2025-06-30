output "db_host" {
  value = aws_db_instance.main.address  
}

output "db_port" {
  description = "RDS connection port"
  value       = aws_db_instance.main.port
}

output "db_identifier" {
  description = "RDS instance identifier"
  value       = aws_db_instance.main.identifier
}