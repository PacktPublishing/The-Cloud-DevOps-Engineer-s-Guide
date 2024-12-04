module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.4.0"

  name            = local.vpc_name
  cidr            = var.vpc_cidr_block
  azs             = ["us-east-1b", "us-east-1c"]
  public_subnets  = var.vpc_public_subnets
  private_subnets = var.vpc_private_subnets

  enable_nat_gateway = var.vpc_enable_nat_gateway
  single_nat_gateway = var.vpc_single_nat_gateway
  create_igw         = true


  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Owners      = var.owners
    Environment = var.environment
  }

  map_public_ip_on_launch = true
}
