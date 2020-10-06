variable "application_name" {
  type        = string
  description = "This is the application name used for tagging resources"
}
variable "vpc_id" {
  type        = string
  description = "This is vpc id used for other resources"
}
variable "container_port" {
  type        = number
  description = "This is the port used for container"
}
variable "repository_url" {
  type        = string
  description = "This is the URL of the repository"
}
variable "private_subnets_ids" {
  type        = list
  description = "This is a list of private subnets ids used for other resources"
}

variable "aws_alb_target_group" {
  type        = string
  description = "This is the target group for ALB"
}