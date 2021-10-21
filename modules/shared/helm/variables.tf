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
  default = "efs-sc"
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

variable "bucket" {
  type = string
}

variable "prefix" {
  type = string
  default = "/artifacts"
}

variable "cf_distribution_id" {
  type = string
}
variable "cf_pubkey_id" {
  type = string
}

variable "cf_pk_pem" {
  type = string
}
