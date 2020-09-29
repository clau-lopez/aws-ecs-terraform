output "vpc_id" {
  value       = aws_vpc.main.id
  description = "This is vpc id used for other resources"
}