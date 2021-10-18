variable "cluster_name" {
  type = string
}

variable "tenant_name" {
  type = string
}

variable "tenant_namespace" {
  type = string
}

variable "storage_class" {
  type    = string
  default = "efs"
}

variable "db_user" {
  type = string
}

variable "db_password" {
  type = string
}

variable "db_name" {
  type = string
}

variable "db_host" {
  type = string
}

variable "server_role_arn" {
  type = string
}

variable "agent_role_arn" {
  type = string
}

variable "service_suffix" {
  type    = string
  default = "teamcity"
}
