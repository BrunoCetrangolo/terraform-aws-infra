# Módulo RDS
#
# Crea una instancia de RDS (MySQL) en las subnets PRIVADAS —
# nunca expuesta directamente a internet. El Security Group solo
# permite conexiones que vengan del Security Group de la EC2, no
# de cualquier IP. Esto es el patrón estándar de arquitectura en
# capas: la app puede hablarle a la base, pero nadie de afuera
# puede conectarse directo a la base.

resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-db-subnet-group"
  subnet_ids = var.private_subnet_ids

  tags = {
    Name = "${var.project_name}-db-subnet-group"
  }
}

resource "aws_security_group" "rds" {
  name        = "${var.project_name}-rds-sg"
  description = "Permite conexiones MySQL solo desde el Security Group de la EC2"
  vpc_id      = var.vpc_id

  ingress {
    description     = "MySQL desde la EC2"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [var.ec2_security_group_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-rds-sg"
  }
}

resource "aws_db_instance" "main" {
  identifier     = "${var.project_name}-db"
  engine         = "mysql"
  engine_version = "8.0"
  instance_class = var.db_instance_class

  allocated_storage = 20
  storage_type      = "gp3"

  db_name  = var.db_name
  username = var.db_username
  password = var.db_password

  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]

  # Para portfolio/testing: sin Multi-AZ y con backups mínimos,
  # para no generar costos innecesarios. En producción real esto
  # se ajusta (multi_az = true, backup_retention_period más alto).
  multi_az                = false
  backup_retention_period = 1
  skip_final_snapshot     = true
  publicly_accessible     = false

  tags = {
    Name = "${var.project_name}-db"
  }
}
