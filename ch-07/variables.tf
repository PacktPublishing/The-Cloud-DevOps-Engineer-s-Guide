variable "aws_region" {
  description = "The AWS region for our resources."
  type        = string
  default     = "us-east-1"
}

variable "random_suffix" {
  description = "A random suffix to ensure the bucket name is unique."
  type        = string
}