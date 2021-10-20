locals {
  bucket_name = "${replace(var.tenant_name, "/\\W|_|\\s/", "")}-artifact-bucket"
}
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = local.bucket_name
  acl    = "private"

  acceleration_status = var.acceleration_status

  #todo enable in the future
  # logging = {
  #     target_bucket = module.log_bucket.s3_bucket_id
  #     target_prefix = "log/"
  # }
  versioning = {
    enabled = false
  }
}
