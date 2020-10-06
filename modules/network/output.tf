output "vpc_id" {
  value       = aws_vpc.main.id
  description = "This is vpc id used for other resources"
}

output "public_subnets_ids" {
  value       = aws_subnet.public.*.id
  description = "This is a list of public subnets ids used for other resources"
}
output "private_subnets_ids" {
  value       = aws_subnet.private.*.id
  description = "This is a list of private subnets ids used for other resources"
}