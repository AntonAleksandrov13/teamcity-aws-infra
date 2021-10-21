output "distribution" {
    value = aws_cloudfront_distribution.tenant_distribution.id
}
output "cf_pub_key_id" {
    value = aws_cloudfront_public_key.tenant_cf_key.id
}

output "cf_pk_key" {
    value = tls_private_key.tenant_cf_pk.private_key_pem
    sensitive = true
}