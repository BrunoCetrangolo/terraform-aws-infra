output "instance_id" {
  description = "ID de la instancia EC2"
  value       = aws_instance.app.id
}

output "public_ip" {
  description = "IP pública de la instancia"
  value       = aws_instance.app.public_ip
}

output "security_group_id" {
  description = "ID del Security Group de la EC2 (lo consume el módulo RDS)"
  value       = aws_security_group.ec2.id
}
