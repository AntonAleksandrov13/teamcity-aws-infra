locals {
  bucket_name     = "${replace(var.tenant_name, "/\\W|_|\\s/", "")}-artifact-bucket"
  artifact_folder = "${var.artifact_folder}/"
}
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket              = local.bucket_name
  acl                 = var.acl
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
resource "aws_s3_bucket_object" "artifact_folder" {
  bucket       = module.s3_bucket.s3_bucket_id
  acl          = var.acl
  key          = local.artifact_folder
  content_type = "application/x-directory"
}

resource "aws_s3_bucket_policy" "access_policy" {
  bucket = module.s3_bucket.s3_bucket_id
  policy = data.aws_iam_policy_document.access_policy.json

  # bucket policy cannot be created on prefix that does not exists. hence depends_on
  depends_on = [
    aws_s3_bucket_object.artifact_folder
  ]
}
data "aws_iam_policy_document" "access_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3_bucket.s3_bucket_arn}/${local.artifact_folder}*"]

    principals {
      type        = "AWS"
      identifiers = [var.oai_arn]
    }
  }
}
