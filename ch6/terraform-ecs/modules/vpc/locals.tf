# Define Local Values in Terraform
locals {
  owners      = var.owners
  environment = var.environment
  name        = "${var.owners}-${var.environment}"
  vpc_name    = "${var.vpc_name}-${var.cluster_name}"
  common_tags = {
    owners      = local.owners
    environment = local.environment
  }
} 