variable "aws_region" {
  type        = string
  description = "This is the region where the infrastructure will be provisioned"
  default     = "us-west-1"
}
variable "application_name" {
  type        = string
  description = "This is the application name useda"
}
variable "vpc_cidr_block" {
  type        = map
  description = "This is the CIDR block used for the VPC"
}
variable "availability_zones" {
  type        = list(string)
  description = "This is the list of AWS availability zones"
}
variable "public_cidrs" {
  type        = map(list(string))
  description = "This is a map with the CIDR blocks for public subnets"
}
variable "private_cidrs" {
  type        = map(list(string))
  description = "This is a map with the CIDR blocks for private subnets"
}
variable "insecure_port" {
  type        = number
  description = "This is the insecure port to allow ingress in security group "
}
variable "secure_port" {
  type        = number
  description = "This is the secure port to allow ingress in security group"
}
variable "bucket_prefix" {
  type        = string
  description = "This is the folder where the logs should be created"
}
variable "container_port" {
  type        = number
  description = "This is the port used for container"
  default     = 8080
}
variable "repository_url" {
  type        = string
  description = "This is the URL of the repository"
  default     = ""
}
variable "allocated_storage" {
  type        = number
  description = "This is allocated storage for the database"
}
variable "instance_class" {
  type        = string
  description = "This is an instance class for DB instance"
}
variable "engine_version" {
  type        = string
  description = "This is the engine version for the engine used"
}
variable "database_name" {
  type        = string
  description = "This is the name of the database"
}