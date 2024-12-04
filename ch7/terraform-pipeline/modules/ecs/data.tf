data "aws_vpc" "vpc" {
  id = var.network.vpc_id
}

data "aws_region" "current" {}

data "aws_ami" "ecs_ami" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn-ami-*-amazon-ecs-optimized"]
  }
}

data "aws_caller_identity" "current" {}