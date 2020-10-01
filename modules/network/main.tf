# VPC
resource "aws_vpc" "main" {
  cidr_block = lookup(var.vpc_cidr_block, terraform.workspace)
  tags = {
    Name        = "${var.application_name}-vpc-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

# Internet Gateway
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.application_name}-igw-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

# Public subnets
resource "aws_subnet" "public" {
  count                   = length(lookup(var.public_cidrs, terraform.workspace))
  vpc_id                  = aws_vpc.main.id
  cidr_block              = element(lookup(var.public_cidrs, terraform.workspace), count.index)
  availability_zone       = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name        = "${var.application_name}-public-subnet-${count.index}-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}