variable "tenant_name" {
  type = string
}

variable "bucket_regional_domain_name" {
  type = string
}

variable "oai_path" {
  type = string
}

variable "origin_path" {
  type    = string
  default = "/artifacts"
}

variable "allowed_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
}

variable "cached_methods" {
  type    = list(string)
  default = ["GET", "HEAD"]
}

variable "viewer_protocol_policy" {
  type    = string
  default = "redirect-to-https"
}

variable "min_ttl" {
  type    = number
  default = 0
}

variable "default_ttl" {
  type    = number
  default = 86400
}

variable "max_ttl" {
  type    = number
  default = 31536000
}

variable "compress" {
  type    = bool
  default = true
}

variable "restriction_type" {
  type    = string
  default = "none"
}

variable "locations" {
  type    = list(string)
  default = ["NL", "RU"]
}

variable "cloudfront_default_certificate" {
  type    = bool
  default = true
}

variable "acm_certificate_arn" {
  type    = string
  default = "acm_cert_arn"
}

variable "iam_certificate_id" {
  type    = string
  default = "iam_cert_id"
}
