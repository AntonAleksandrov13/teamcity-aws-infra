terraform {
  backend "s3" {
    key = "route53"
  }
}
module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = var.zones
}