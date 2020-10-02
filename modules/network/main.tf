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

# Private Subnets
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = element(lookup(var.private_cidrs, terraform.workspace), count.index)
  availability_zone = element(var.availability_zones, count.index)
  count             = length(lookup(var.private_cidrs, terraform.workspace))
  tags = {
    Name        = "${var.application_name}-private-subnet-${count.index}-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

# Route table for public subnets
resource "aws_route_table" "public" {
  count  = length(lookup(var.public_cidrs, terraform.workspace))
  vpc_id = aws_vpc.main.id
  tags = {
    Name        = "${var.application_name}-route-table-public-${count.index}-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}

resource "aws_route" "public" {
  count                  = length(compact(lookup(var.public_cidrs, terraform.workspace)))
  route_table_id         = element(aws_route_table.public.*.id, count.index)
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = element(aws_internet_gateway.main.*.id, count.index)
}

resource "aws_route_table_association" "public" {
  count          = length(lookup(var.public_cidrs, terraform.workspace))
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = element(aws_route_table.public.*.id, count.index)
}

# Elastic IP
resource "aws_eip" "eip" {
  count = length(lookup(var.private_cidrs, terraform.workspace))
  vpc   = true
  tags = {
    Name        = "${var.application_name}-eip-${count.index}-${terraform.workspace}"
    Environment = "${terraform.workspace}"
  }
}
