output "db_endpoint" {
  description = "Endpoint de conexión de la base de datos"
  value       = aws_db_instance.main.endpoint
}

output "db_name" {
  description = "Nombre de la base de datos"
  value       = aws_db_instance.main.db_name
}
