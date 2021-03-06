variable "cluster_name" {
  type = string
}

variable "cluster_version" {
  type    = string
  default = "1.21"
}

variable "cluster_create_timeout" {
  type    = string
  default = "20m"
}

variable "map_users" {
  description = "Additional IAM roles to add to the aws-auth configmap."
  type = list(object({
    userarn  = string
    username = string
    groups   = list(string)
  }))
}

variable "cluster_endpoint_public_access" {
  type    = bool
  default = true
}

variable "cluster_endpoint_private_access" {
  type    = bool
  default = true
}

variable "eks_master_subnets" {
  type = list(string)
}

variable "eks_worker_subnets" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "enable_irsa" {
  type    = bool
  default = true
}

variable "manage_aws_auth" {
  type    = bool
  default = true
}

# potentially can be used to create worker groups, however seems redundant. we aim to achieve consistency accross multiple AZs
## see worker_group_default for available options: https://github.com/terraform-aws-modules/terraform-aws-eks/blob/master/local.tf#L28
#variable "worker_groups" {
#  type = list(object({
#    key_name             = string
#    instance_type        = string
#    asg_min_size         = number
#    asg_max_size         = number
#    asg_desired_capacity = number
#    subnets              = list(string)
#    kubelet_extra_args   = string
#    tags = list(object({
#      key                 = string
#      propagate_at_launch = string
#      value               = string
#    }))
#
#  }))
#  default = []
#}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

variable "max_eks_workers_per_asg" {
  type    = number
  default = 25
}

variable "desired_eks_workers_per_asg" {
  type    = number
  default = 1
}

variable "min_eks_workers_per_asg" {
  type    = number
  default = 1
}
