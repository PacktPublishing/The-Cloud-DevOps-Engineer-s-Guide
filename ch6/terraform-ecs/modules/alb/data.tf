data "aws_vpc" "vpc" {
  id = var.network.vpc_id
}