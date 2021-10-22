# this config ensures that states between tenants and global infra are stored separately
# yet, this creates a state dependency trouble of having global infra in check before tenants can use it
terraform {
  backend "s3" {
    region = "eu-west-1"
    key    = "tenantone_infra"
  }
}
