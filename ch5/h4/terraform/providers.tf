provider "aws" {
  region = var.aws_region
}

# Terraform state storage backend (optional, if you want to use a remote backend like S3)
# terraform {
#   backend "s3" {
#     bucket = "your-state-bucket"
#     key    = "terraform/state"
#     region = "us-east-1"
#   }
# }