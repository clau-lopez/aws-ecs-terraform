# Security group to ALB
resource "aws_security_group" "sg" {
  name   = "${var.application_name}-sg-alb-${terraform.workspace}"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = var.insecure_port
    to_port          = var.insecure_port
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  ingress {
    protocol         = "tcp"
    from_port        = var.secure_port
    to_port          = var.secure_port
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    protocol         = "-1"
    from_port        = 0
    to_port          = 0
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  tags = {
    Name        = "${var.application_name}-sg-alb-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}