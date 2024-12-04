resource "aws_lb_target_group" "default" {
  name     = "${var.cluster_name}-default"
  vpc_id   = data.aws_vpc.vpc.id
  port     = 80
  protocol = "HTTP"

  health_check {
    matcher             = "301,200"
    path                = "/"
    interval            = 10
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }
}
