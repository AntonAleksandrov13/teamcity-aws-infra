module "zones" {
  source  = "terraform-aws-modules/route53/aws//modules/zones"
  version = "~> 2.0"

  zones = {
    "teamcity-anton-cloud.com" = {
      comment = ""
    }
  }

  tags = {
    ManagedBy = "Terraform"
  }
}