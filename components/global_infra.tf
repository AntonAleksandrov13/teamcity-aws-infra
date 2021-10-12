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
  source = "../../../modules/global/route53"
  zones  = var.route53_zones
}

module "bastion" {
  source     = "../../../modules/global/bastion"
  vpc_id     = module.vpc.vpc_id
  subnets    = module.vpc.private_subnet_ids
}

module "eks" {
  source             = "../../../modules/global/eks"
  cluster_name       = var.cluster_name
  instance_type      = vars.instance_type
  vpc_id             = module.vpc.vpc_id
  eks_worker_subnets = module.vpc.private_subnet_ids
  eks_master_subnets = module.vpc.private_subnet_ids
  map_users          = var.map_users
}
