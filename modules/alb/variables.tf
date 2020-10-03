variable "vpc_id" {
  type        = string
  description = "This is vpc id used for other resources"
}

variable "insecure_port" {
  type        = number
  description = "This is the insecure port to allow ingress in security group "
}
variable "secure_port" {
  type        = number
  description = "This is the secure port to allow ingress in security group"
}