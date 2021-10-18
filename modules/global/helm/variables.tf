variable "cluster_name" {
  type = string
}

variable "efs_id" {
  type = string
}

variable "region" {
  type = string
}

variable "aws_efs_csi_driver_role_arn" {
  type = string
}

variable "cluster_autoscaler_role_arn" {
  type = string
}

variable "external_dns_role_arn" {
  type = string
}

variable "txt_owner_id" {
  type = string
}
