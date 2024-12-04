resource "aws_lb_listener" "listener_http" {  
  load_balancer_arn = aws_lb.public_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.default.arn 
  }

  lifecycle {
    ignore_changes = [
      default_action
    ]
  }
}
