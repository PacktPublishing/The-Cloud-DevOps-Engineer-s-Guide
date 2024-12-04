variable "cluster_name" {
  type = string
}

variable "network" {
  type = object({
    vpc_id  = string
    subnets = list(string)
  })
}

