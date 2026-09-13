variable "aws_region" {
  description = "Región de AWS donde se despliega todo"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Nombre del proyecto, usado como prefijo en los tags de todos los recursos"
  type        = string
  default     = "terraform-aws-infra"
}

# --- Red ---
variable "vpc_cidr" {
  description = "Bloque CIDR de la VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "CIDRs de las subnets públicas"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "CIDRs de las subnets privadas"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  description = "Availability Zones a usar (tienen que existir en tu región)"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

# --- EC2 ---
variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Nombre del key pair de EC2 existente en tu cuenta de AWS, para acceso SSH"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "Tu IP pública en formato CIDR (ej: '181.23.45.67/32'), único origen permitido para SSH"
  type        = string
}

# --- RDS ---
variable "db_instance_class" {
  description = "Clase de instancia de la base de datos"
  type        = string
  default     = "db.t3.micro"
}

variable "db_name" {
  description = "Nombre de la base de datos"
  type        = string
  default     = "appdb"
}

variable "db_username" {
  description = "Usuario administrador de la base de datos"
  type        = string
  sensitive   = true
}

variable "db_password" {
  description = "Contraseña del usuario administrador. Definila en terraform.tfvars (nunca se sube a git) o con la variable de entorno TF_VAR_db_password."
  type        = string
  sensitive   = true
}
