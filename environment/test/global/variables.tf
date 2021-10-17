variable "region" {
  default = "eu-west-1"
  type    = string
}

variable "terraform-bucket-name" {
  default = "terraform-state-teamcity-test-task"
  type    = string

}

variable "vpc_name" {
  type = string
}

variable "cidr" {
  type = string
}

variable "public_subnets" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "route53_zones" {
  type    = any
  default = {}
}


variable "cluster_name" {
  type = string
}

variable "map_users" {
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}

variable "instance_type" {
  type = string
}

variable "desired_eks_workers_per_asg" {
  type = number
}

variable "min_eks_workers_per_asg" {
  type = number
}
