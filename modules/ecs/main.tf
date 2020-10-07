# Security group to ECS Task
resource "aws_security_group" "ecs_tasks" {
  name   = "${var.application_name}-sg-ecs-task-${terraform.workspace}"
  vpc_id = var.vpc_id

  ingress {
    protocol         = "tcp"
    from_port        = var.container_port
    to_port          = var.container_port
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
    Name        = "${var.application_name}-sg-ecs-task-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

# ECS Cluster
resource "aws_ecs_cluster" "main" {
  name = "${var.application_name}-cluster-${terraform.workspace}"

  tags = {
    Name        = "${var.application_name}-cluster-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

# IAM Policy document
data "aws_iam_policy_document" "policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
# IAM Role
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.application_name}-ecsTaskExecutionRole-${terraform.workspace}"
  assume_role_policy = data.aws_iam_policy_document.policy.json
}

# IAM Role policy attachment
resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Cloudwatch log group
resource "aws_cloudwatch_log_group" "logs-ecs" {
  name = "${var.application_name}-log-ecs-${terraform.workspace}"

  tags = {
    Name        = "${var.application_name}-log-ecs-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

# Data source to get current Region
data "aws_region" "current" {}

# Template file for container definitions
data "template_file" "container_definitions" {
  template = file("${path.module}/task-definitions/service.json.tpl")

  vars = {
    container_name  = "${var.application_name}-container-${terraform.workspace}"
    container_image = "${var.repository_url}:latest"
    container_port  = var.container_port
    awslogs_group   = "${var.application_name}-log-ecs-${terraform.workspace}"
    region          = data.aws_region.current.name
  }
}

# Task Definition
resource "aws_ecs_task_definition" "main" {
  family                   = "${var.application_name}-task-${terraform.workspace}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = data.template_file.container_definitions.rendered
  tags = {
    Name        = "${var.application_name}-task-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

# ECS Service
resource "aws_ecs_service" "main" {
  name                               = "${var.application_name}-ecs-service-${terraform.workspace}"
  cluster                            = aws_ecs_cluster.main.id
  task_definition                    = aws_ecs_task_definition.main.arn
  desired_count                      = 2
  deployment_minimum_healthy_percent = 50
  deployment_maximum_percent         = 200
  launch_type                        = "FARGATE"
  scheduling_strategy                = "REPLICA"
  force_new_deployment               = true

  network_configuration {
    security_groups = [aws_security_group.ecs_tasks.id]
    subnets         = var.private_subnets_ids
  }

  load_balancer {
    target_group_arn = var.aws_alb_target_group
    container_name   = "${var.application_name}-container-${terraform.workspace}"
    container_port   = var.container_port
  }

  lifecycle {
    ignore_changes = [task_definition, desired_count]
  }
}
# Autoscaling
resource "aws_appautoscaling_target" "ecs_target" {
  max_capacity       = 4
  min_capacity       = 2
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.main.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

# Autoscaling policy for Memory
resource "aws_appautoscaling_policy" "ecs_policy_memory" {
  name               = "memory-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
    target_value = 80
  }
}

# Autoscaling policy for CPU
resource "aws_appautoscaling_policy" "ecs_policy_cpu" {
  name               = "cpu-autoscaling"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target.service_namespace

  target_tracking_scaling_policy_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }

    target_value = 60
  }
}