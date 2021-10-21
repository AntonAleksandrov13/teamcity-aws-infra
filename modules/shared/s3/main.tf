locals {
  bucket_name = "${replace(var.tenant_name, "/\\W|_|\\s/", "")}-artifact-bucket"
}
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket              = local.bucket_name
  acl                 = "private"
  policy              = data.aws_iam_policy_document.s3_policy.json
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
data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_bucket.s3_bucket_arn}/artifacts/*"]

    principals {
      type        = "AWS"
      identifiers = [var.oai_arn]
    }
  }
}
