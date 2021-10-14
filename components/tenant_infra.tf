provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws        = ">= 3.22.0"
    kubernetes = ">= 1.11.1"
  }
}
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    region  = var.region
    encrypt = true
    key     = "vpc"
    bucket  = var.terraform_bucket
  }

  workspace = var.env
}

module "rds" {
    source          = "../../../modules/shared/rds"
    vpc_id = var.vpc_id
}