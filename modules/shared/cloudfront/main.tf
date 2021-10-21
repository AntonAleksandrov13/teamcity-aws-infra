locals {
  s3_origin_id            = "${var.tenant_name}-origin"
  create_geo_restrictions = length(regexall("none", var.restriction_type)) == 0
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
  name  = "${var.tenant_name}-group"
}

resource "aws_cloudfront_distribution" "tenant_distribution" {
  origin {
    domain_name = var.bucket_regional_domain_name
    origin_id   = local.s3_origin_id
    origin_path = var.origin_path

    s3_origin_config {
      origin_access_identity = var.oai_path
    }
  }
  enabled = true
  default_cache_behavior {
    allowed_methods  = var.allowed_methods
    cached_methods   = var.allowed_methods
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = var.viewer_protocol_policy
    min_ttl                = var.min_ttl
    default_ttl            = var.default_ttl
    max_ttl                = var.max_ttl
    compress               = var.compress
    trusted_key_groups     = [aws_cloudfront_key_group.cf_keygroup.id]
  }
  restrictions {
    geo_restriction {
      restriction_type = var.restriction_type
      locations        = local.create_geo_restrictions ? var.locations : null
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = var.cloudfront_default_certificate
    acm_certificate_arn            = var.cloudfront_default_certificate ? null : var.acm_certificate_arn
    iam_certificate_id             = var.cloudfront_default_certificate ? null : var.iam_certificate_id
  }
}
