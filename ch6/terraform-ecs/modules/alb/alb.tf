resource "aws_lb" "public_alb" {
  name               = "${var.cluster_name}-alb"
  load_balancer_type = "application"
  subnets            = var.network.subnets
  security_groups    = [aws_security_group.alb_security_group.id]
  internal           = false
}

resource "aws_security_group" "alb_security_group" {
  name        = "${var.cluster_name}-alb-sg"
  description = "Enables web access to all IPs"
  vpc_id      = var.network.vpc_id

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
