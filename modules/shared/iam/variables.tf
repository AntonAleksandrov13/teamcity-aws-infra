variable "tenant_name" {
  type = string
}

variable "tenant_namespace" {
  type = string
}

variable "tenant_bucket_arn" {
  type = string
}

variable "oidc_url" {
  type = string
}

variable "tenant_server_serviceaccount" {
  type    = string
  default = "teamcity-server"
}

variable "tenant_agent_serviceaccount" {
  type    = string
  default = "teamcity-agent"
}
