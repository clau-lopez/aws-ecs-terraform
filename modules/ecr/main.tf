# ECR
resource "aws_ecr_repository" "main" {
  name = "${var.application_name}-repository-${terraform.workspace}"

  image_scanning_configuration {
    scan_on_push = true
  }
  tags = {
    Name        = "${var.application_name}-repository-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

# ECR lifecycle policy
resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name
  policy     = file("${path.module}/lifecycle_policy.json")
}