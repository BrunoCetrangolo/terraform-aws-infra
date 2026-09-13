output "vpc_id" {
  description = "ID de la VPC creada"
  value       = module.vpc.vpc_id
}

output "ec2_public_ip" {
  description = "IP pública de la instancia EC2 (para conectarte por SSH)"
  value       = module.ec2.public_ip
}

output "rds_endpoint" {
  description = "Endpoint de conexión de la base de datos RDS"
  value       = module.rds.db_endpoint
}
