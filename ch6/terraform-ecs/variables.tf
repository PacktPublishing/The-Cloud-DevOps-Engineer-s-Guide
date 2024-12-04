# VPC Name
variable "vpc_name" {
  description = "VPC Name"
  type        = string
  default     = "vpc" # Change it to the name you want your VPC to have
}

# VPC CIDR Block
variable "vpc_cidr_block" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

# VPC Public Subnets
variable "vpc_public_subnets" {
  description = "VPC Public Subnets"
  type        = list(string)
  default     = ["10.0.10.0/24", "10.0.20.0/24"]
}

# VPC Private Subnets
variable "vpc_private_subnets" {
  description = "VPC Private Subnets"
  type        = list(string)
  default     = ["10.0.30.0/24", "10.0.40.0/24"]
}

# VPC Enable NAT Gateway (True or False) 
variable "vpc_enable_nat_gateway" {
  description = "Enable NAT Gateways for Private Subnets Outbound Communication"
  type        = bool
  default     = true
}

# VPC Single NAT Gateway (True or False)
variable "vpc_single_nat_gateway" {
  description = "Enable only single NAT Gateway in one Availability Zone to save costs during our demos"
  type        = bool
  default     = true
}

variable "aws_region" {
  description = "Region in which AWS Resources to be created"
  type        = string
  default     = "us-east-1" # Change it accordingly
}

variable "environment" {
  description = "Environment Variable used as a prefix"
  type        = string
  default     = "dev" # This can also be chenged depending on your dev environment
}

variable "cluster_name" {
  type     = string
  default  = "your-app" # Change it to the name of your application
}

variable "container_name" {
  type     = string
  default  = "project-app" # Change it to the name of your application
}

variable "container_image" {
  type    = string
  default = "your-project:latest" # Change to the name of your project
}

variable "task_family" {
  type     = string
  default  = "your_app" # Change it to the name of your application
}

variable "service_name" {
  type     = string
  default  = "project-app" # Change it to the name of your application
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  default     = "t3.micro"
}
