variable "project_name" {
  description = "Nombre del proyecto, usado como prefijo en los tags"
  type        = string
}

variable "vpc_id" {
  description = "ID de la VPC donde se crea el Security Group"
  type        = string
}

variable "public_subnet_id" {
  description = "ID de la subnet pública donde se lanza la instancia"
  type        = string
}

variable "instance_type" {
  description = "Tipo de instancia EC2"
  type        = string
  default     = "t2.micro"
}

variable "key_name" {
  description = "Nombre del key pair de EC2 para acceso SSH (tiene que existir previamente en tu cuenta de AWS)"
  type        = string
}

variable "allowed_ssh_cidr" {
  description = "CIDR permitido para conectarse por SSH (ej: 'TU.IP.PUB.LICA/32'). Nunca usar 0.0.0.0/0 acá."
  type        = string
}
