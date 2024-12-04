variable "cluster_name" {
  type = string
}

variable "container_name" {
  type = string
}

variable "container_image" {
  type = string
}

variable "task_family" {
  type = string
}

variable "service_name" {
  type = string
}

variable "network" {
  type = object({
    vpc_id  = string
    subnets = list(string)
  })
}

variable "auto_scalling" {
  type = object({
    instance_type     = string
    min_instances     = number
    desired_instances = number
    max_instances     = number
    key_name          = string
  })
}

variable "aws_lb_target_group_default_arn" {
  type = string
}
