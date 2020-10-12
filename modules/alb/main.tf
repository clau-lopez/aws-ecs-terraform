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

# Data source to get Account ID
data "aws_caller_identity" "current" {}

# Data source to get the Account ID of the AWS Elastic Load Balancing Service Account in a given region
data "aws_elb_service_account" "main" {}

# AWS IAM Policy document
data "aws_iam_policy_document" "policy" {
  version = "2012-10-17"
  statement {
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.application_name}-alb-logs-${terraform.workspace}/${var.bucket_prefix}/AWSLogs/${data.aws_caller_identity.current.account_id}/*"]
    principals {
      type        = "AWS"
      identifiers = ["${data.aws_elb_service_account.main.arn}"]
    }
  }
}

# Bucket to store ALB logs
resource "aws_s3_bucket" "lb_logs" {
  bucket        = "${var.application_name}-alb-logs-${terraform.workspace}"
  acl           = "private"
  force_destroy = true
  policy        = data.aws_iam_policy_document.policy.json

  tags = {
    Name        = "${var.application_name}-alb-logs-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

# ALB: Application Load Balancer
resource "aws_lb" "main" {
  name                       = "${var.application_name}-alb-${terraform.workspace}"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.sg.id]
  subnets                    = var.public_subnets_ids
  enable_deletion_protection = false

  access_logs {
    bucket  = aws_s3_bucket.lb_logs.bucket
    prefix  = var.bucket_prefix
    enabled = true
  }

  tags = {
    Name        = "${var.application_name}-alb-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

# Target group
resource "aws_alb_target_group" "main" {
  name        = "${var.application_name}-tg-${terraform.workspace}"
  port        = var.insecure_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "ip"
  depends_on  = [aws_lb.main]

  health_check {
    path    = "/"
    port    = var.container_port
    timeout = "3"
    matcher = "200"
  }
}

# Listener HTTP
resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_lb.main.id
  port              = var.insecure_port
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.main.id
    type             = "forward"
  }
}