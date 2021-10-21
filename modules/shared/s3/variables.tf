variable "tenant_name" {
  type = string
}

variable "acceleration_status" {
  type = string
  default = "Enabled"
}
variable "oai_arn" {
type = string
}

variable "acl" {
  type = string
  default = "private"
}

variable "artifact_folder" {
  type = string
  default = "artifacts"
}