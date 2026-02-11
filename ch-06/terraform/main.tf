# App Runner Staging

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

resource "aws_apprunner_service" "staging" {
  service_name = "simple-flask-app-staging"

  source_configuration {
    image_repository {
      image_identifier      = var.ecr_image_identifier
      image_repository_type = "ECR"
    }
    auto_deployments_enabled = false
  }
}

variable "ecr_image_identifier" {
  description = "The full URI of the Docker image in ECR."
  type        = string
}

output "service_url" {
  value = aws_apprunner_service.staging.service_url
}