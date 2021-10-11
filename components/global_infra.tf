provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    key = "global_infra"
  }
}

module "vpc" {
  source          = "../../../modules/global/vpc"
  vpc_name        = var.vpc_name
  cidr            = var.cidr
  azs             = ["${var.region}a", "${var.region}b", "${var.region}c"]
  public_subnets  = var.public_subnets
  private_subnets = var.private_subnets
}

module "route53" {
  source          = "../../../modules/global/route53"
  zones = var.route53_zones
}