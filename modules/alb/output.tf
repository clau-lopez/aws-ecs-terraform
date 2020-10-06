output "aws_alb_target_group" {
  value       = aws_alb_target_group.main.arn
  description = "This is the target group for ALB"
}