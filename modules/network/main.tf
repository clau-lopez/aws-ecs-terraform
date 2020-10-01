resource "aws_vpc" "main" {
  cidr_block = lookup(var.vpc_cidr_block, terraform.workspace)
  tags = {
    Name        = "${var.application_name}-vpc-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.application_name}-igw-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}