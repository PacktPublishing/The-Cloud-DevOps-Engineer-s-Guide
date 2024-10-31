variable "repository_name" {
  description = "Name of the ECR repository"
  type        = string
}

variable "owners" {
  description = "Owner of the repository"
  type        = string
}

variable "environment" {
  description = "Environment where the repository will be used"
  type        = string
}