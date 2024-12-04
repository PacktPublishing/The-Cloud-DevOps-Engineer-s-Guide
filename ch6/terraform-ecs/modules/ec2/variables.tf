variable "region" {
  description = "The region where the EC2 instance will be created"
  default     = "us-east-1"
}

variable "instance_type" {
  description = "Type of the EC2 instance"
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name of the SSH key for accessing the instance"
}

variable "network" {
  type = object({
    vpc_id  = string
    subnets = list(string)
  })
}