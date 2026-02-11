# Refactored Version Using Variables

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name

  tags = {
    Name      = "My DevOps Book Bucket"
    ManagedBy = "Terraform"
  }
}