# AWS Region
variable "aws_region" {
  description = "The AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# VPC Variables
variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_public_subnets" {
  description = "List of CIDR blocks for public subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

variable "vpc_private_subnets" {
  description = "List of CIDR blocks for private subnets"
  type        = list(string)
  default     = ["10.0.30.0/24", "10.0.40.0/24"]
}

variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateway for the private subnets"
  type        = bool
  default     = true
}

variable "vpc_single_nat_gateway" {
  description = "Create a single NAT Gateway to save costs"
  type        = bool
  default     = true
}

# EC2 Variables
variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "The name of the SSH key pair to use for EC2 instances"
  type        = string
}

variable "owners" {
  description = "Owner of the environment (used for tagging)"
  type        = string
}

variable "environment" {
  description = "Environment name (used for tagging)"
  type        = string
}

# IAM Role Variables
variable "iam_role_name" {
  description = "Name of the IAM role for EC2 instances"
  type        = string
}

# ECR Repository Name
variable "ecr_repo_name" {
  description = "Name of the ECR repository"
  type        = string
}