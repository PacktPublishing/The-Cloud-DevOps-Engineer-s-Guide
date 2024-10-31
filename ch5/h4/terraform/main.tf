# VPC Module
module "vpc" {
  source                      = "./modules/vpc"
  vpc_name                   = "${var.owners}-${var.environment}-vpc"
  vpc_cidr_block             = var.vpc_cidr_block
  vpc_public_subnets         = var.vpc_public_subnets
  vpc_private_subnets        = var.vpc_private_subnets
  vpc_enable_nat_gateway     = var.vpc_enable_nat_gateway
  vpc_single_nat_gateway      = var.vpc_single_nat_gateway
  aws_region                 = var.aws_region
  environment                = var.environment
  owners                     = var.owners
}

# EC2 and Security Module
module "ec2_security" {
  source         = "./modules/ec2"
  vpc_id         = module.vpc.vpc_id
  subnets        = module.vpc.public_subnets
  instance_type  = var.instance_type
  key_name       = var.key_name
  owners         = var.owners
  environment    = var.environment
  depends_on = [module.vpc, module.iam_roles]
}

# IAM Roles Module
module "iam_roles" {
  source     = "./modules/iam_roles"
  environment = var.environment
  owners      = var.owners
  depends_on = [module.ecr]
}

# ECR Module
module "ecr" {
  source           = "./modules/ecr"
  repository_name  = "${var.owners}-${var.environment}-ecr-repo"
  owners           = var.owners
  environment      = var.environment
  depends_on = [module.vpc]
}

output "ecr_repo_url" {
  description = "ECR repository URL"
  value       = module.ecr.repository_url
}

output "ec2_instance_ids" {
  description = "List of EC2 instance IDs"
  value       = module.ec2_security.instance_ids
}