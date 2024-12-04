output "alb_dns" {
  value = aws_lb.public_alb.dns_name
}

output "alb_name" {
  value = aws_lb.public_alb.name
}

output "alb_arn" {
  value = aws_lb.public_alb.arn
}

output "listener_arn" {
  value = aws_lb_listener.listener_http.arn
}

output "aws_lb_target_group_default_arn" {
  value = aws_lb_target_group.default.arn
}