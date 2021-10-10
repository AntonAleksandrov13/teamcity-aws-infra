provider "aws" {
  region = var.region
}

module "vpc" {
  source = "../../../modules/global/vpc"
  vpc_name = var.vpc_name
  cidr = var.cidr
  azs = var.azs
  public_subnets = var.public_subnets
  private_subnets = var.private_subnets
}