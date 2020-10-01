variable "application_name" {
  type        = string
  description = "This is the application name used for tagging resources"
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
