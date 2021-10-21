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
  type    = string
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

variable "hosted_zone" {
  type = string
}

variable "logging_enabled" {
  type = bool
  default = true
}

variable "network_policy_enabled" {
  type = bool
  default = true
}

variable "cluster_issuer_name" {
  type = string
  default = "selfsigned-cluster-issuer"
}

variable "resource_quota_enabled" {
  type = bool
  default = true
}

variable "resource_quota_cpu" {
  type = string
  default = "2000"
}

variable "resource_quota_memory" {
  type = string
  default = "5Gi"
}

variable "resource_quota_pods" {
  type = string
  default = "5"
}