variable "project_name" {
  description = "Nombre del proyecto, usado como prefijo en los tags"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC donde se crea el Security Group de la RDS"
  type        = string
}

variable "private_subnet_ids" {
  description = "IDs de las subnets privadas donde vive la RDS"
  type        = list(string)
}

variable "ec2_security_group_id" {
  description = "Security Group de la EC2, único origen permitido para conectarse a la RDS"
  type        = string
}

variable "db_instance_class" {
  description = "Clase de instancia de la RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Usuario administrador de la base"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Contraseña del usuario administrador. Nunca hardcodear: pasar vía terraform.tfvars (gitignored) o variable de entorno TF_VAR_db_password."
  type        = string
  sensitive   = true
}
