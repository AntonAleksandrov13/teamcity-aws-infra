terraform {
  backend "s3" {
    region = "eu-west-1"
    key    = "tenantone_infra"
  }
}
