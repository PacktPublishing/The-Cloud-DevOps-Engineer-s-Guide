terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0.0"
    }
  }

#  backend "s3" {
#    bucket         = "book-terraform-state"
#    key            = "terraform.tfstate"
#    region         = "us-east-1"
#  }
}