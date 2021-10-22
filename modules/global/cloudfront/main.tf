variable "oai_name" {
  type    = string
  default = "TeamCityOAI"
}

# AWS limits us to 100 OAIs per account. Instead of creating one OAI per tenant we will have one OAI per environment
resource "aws_cloudfront_origin_access_identity" "global_oai" {
  comment = var.oai_name
}

output "oai_arn" {
  value = aws_cloudfront_origin_access_identity.global_oai.iam_arn
}

output "oai_path" {
  value = aws_cloudfront_origin_access_identity.global_oai.cloudfront_access_identity_path
}