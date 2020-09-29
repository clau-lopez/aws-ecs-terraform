variable "aws_region" {
  type        = string
  description = "This is the region where the infrastructure will be provisioned"
  default     = "us-west-2"
}
variable "application_name" {
  type        = string
  description = "This is the application name used for tagging resources"
}
variable "vpc_cidr_block" {
  type        = map
  description = "This is the CIDR block used for the VPC"
}