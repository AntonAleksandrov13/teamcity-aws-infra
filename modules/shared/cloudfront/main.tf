locals {
  tenant_name  = replace(var.tenant_name, "/\\W|_|\\s/", "")
  s3_origin_id = "${local.tenant_name}-origin"
  oai_id       = "${local.tenant_name}-oai"
}

resource "tls_private_key" "tenant_cf_pk" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "aws_cloudfront_public_key" "tenant_cf_key" {
  encoded_key = tls_private_key.tenant_cf_pk.public_key_pem
}

resource "aws_cloudfront_key_group" "cf_keygroup" {
  items = [aws_cloudfront_public_key.tenant_cf_key.id]
  name  = "${local.tenant_name}-group"
}

resource "aws_cloudfront_distribution" "tenant_distribution" {
  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    origin_path = "/artifacts"

    s3_origin_config {
      origin_access_identity = var.oai_path
    }
  }
  enabled = true
  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 86400
    max_ttl                = 31536000
    compress               = true
    trusted_key_groups     = [aws_cloudfront_key_group.cf_keygroup.id]
  }
  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
