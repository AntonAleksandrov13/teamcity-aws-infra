variable "oid_name" {
  type    = string
  default = "TeamCityOID"
}

resource "aws_cloudfront_origin_access_identity" "global_oai" {
  comment = var.oid_name
}

output "oai_arn" {
  value = aws_cloudfront_origin_access_identity.global_oai.iam_arn
}

output "oai_path" {
  value = aws_cloudfront_origin_access_identity.global_oai.cloudfront_access_identity_path
}