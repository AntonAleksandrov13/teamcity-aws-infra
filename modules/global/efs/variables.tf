variable "vpc_id" {
  type = string
}
variable "cluster_name" {
  type = string
}

variable "eks_worker_subnets" {
  type = list(string)
}

variable "throughput_mode" {
  type    = string
  default = "provisioned"
}

variable "provisioned_throughput_in_mibps" {
  type    = number
  default = 10
}

variable "worker_security_group_id" {
  type = string
}
