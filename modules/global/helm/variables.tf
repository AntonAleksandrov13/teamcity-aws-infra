variable "cluster_name" {
    type = string
}

variable "efs_id" {
    type = string
}

variable "region" {
    type = string
}

variable "provisioner_name" {
    type = string
    default = "example.com/efs"
}

variable "storage_class_name" {
    type = string
    default = "efs"
}

variable "cluster_autoscaler_role_arn" {
  type = string
}