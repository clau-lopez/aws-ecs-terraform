provider "aws" {
  region = var.aws_region
  version = "~> 3.4.0"
}
terraform {
    required_version = "~> 0.13.2"
    backend "s3" {}
}