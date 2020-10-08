variable "application_name" {
  type        = string
  description = "This is the application name used for tagging resources"
}
variable "private_subnets_ids" {
  type        = list
  description = "This is a list of private subnets ids used for other resources"
}
variable "vpc_id" {
  type        = string
  description = "This is vpc id used for other resources"
}
variable "private_cidrs" {
  type        = map(list(string))
  description = "This is a map with the CIDR blocks for private subnets"
}

variable "instance_class" {
  type        = string
  description = "This is an instance class for DB instance"
}
variable "engine_version" {
  type        = string
  description = "This is the engine version for the engine used"
}

