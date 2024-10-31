# Instance type for EC2
variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t3.micro"
}

# Key name for SSH access
variable "key_name" {
  description = "Key name for EC2 instances"
  type        = string
}

# List of subnets where instances will be launched
variable "subnets" {
  description = "Subnets for EC2 instances"
  type        = list(string)
}

# VPC ID for the security group
variable "vpc_id" {
  description = "ID of the VPC"
  type        = string
}

# Owners and Environment tags
variable "owners" {
  type        = string
  description = "Owner of the environment"
}

variable "environment" {
  type        = string
  description = "Environment tag for the EC2 instances"
}