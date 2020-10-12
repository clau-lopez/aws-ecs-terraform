# Subnet used by RDS
resource "aws_db_subnet_group" "subnet_group" {
  name        = "${var.application_name}-rds-subnet-group-${terraform.workspace}"
  description = "RDS subnet group"
  subnet_ids  = var.private_subnets_ids
  tags = {
    Name        = "${var.application_name}-rds-subnet-group-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

# Security group for RDS
resource "aws_security_group" "rds_sg" {
  name        = "${var.application_name}-sg-rds-${terraform.workspace}"
  description = "Security Group"
  vpc_id      = var.vpc_id

  # allow traffic for TCP 5432
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = lookup(var.private_cidrs, terraform.workspace)
  }

  # outbound internet access
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.application_name}-sg-rds-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

# Secret manager
data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "${terraform.workspace}/db-creds"
}

locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}

# RDS instance
resource "aws_db_instance" "rds" {
  identifier             = "${var.application_name}-database-${terraform.workspace}"
  allocated_storage      = var.allocated_storage
  engine                 = "postgres"
  engine_version         = var.engine_version
  instance_class         = var.instance_class
  name                   = var.database_name
  username               = local.db_creds.username
  password               = local.db_creds.password
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.id
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot    = true
  deletion_protection    = false
  tags = {
    Name        = "${var.application_name}-database-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}
