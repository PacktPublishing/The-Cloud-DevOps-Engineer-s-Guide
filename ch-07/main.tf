terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }

  backend "s3" {
    bucket = "my-devops-book-tfstate-12345" # Use the name of the bucket you created [cite: 156]
    key    = "staging/terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_s3_bucket" "staging_bucket" {
  bucket = "my-staging-bucket-${var.random_suffix}"

  tags = {
    Name        = "Staging Bucket"
    ManagedBy   = "Terraform via GitHub Actions"
  }
}