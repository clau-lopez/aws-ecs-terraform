variable "application_name" {
  type        = string
  description = "This is the application name used for tagging resources"
}
variable "insecure_port" {
  type        = number
  description = "This is the insecure port to allow ingress in security group "
}
variable "vpc_id" {
  type        = string
  description = "This is vpc id used for other resources"
}