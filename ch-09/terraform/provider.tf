provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = var.project_name
      Identifier  = "DevOps Handguide Book"
      ManagedBy   = "Terraform"
    }
  }
}