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
variable "public_subnets_ids" {
  type        = list
  description = "This is a list of public subnets ids used for other resources"
}
variable "bucket_prefix" {
  type        = string
  description = "This is the folder where the logs should be created"
}