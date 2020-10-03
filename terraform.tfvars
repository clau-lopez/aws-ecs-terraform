application_name   = "my-app"
availability_zones = ["us-west-1a", "us-west-1b"]
insecure_port      = 80
secure_port        = 443



# Variables depending on environments
vpc_cidr_block = {
  dev = "10.0.0.0/16",
}

public_cidrs = {
  tst = ["10.0.2.0/24", "10.0.3.0/24"]
  dev = ["10.0.2.0/24", "10.0.3.0/24"]
}

private_cidrs = {
  tst = ["10.0.0.0/24", "10.0.1.0/24"]
  dev = ["10.0.0.0/24", "10.0.1.0/24"]
}