provider "aws" {
  region = var.region
}

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws        = ">= 3.22.0"
    kubernetes = ">= 1.11.1"
  }
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
  source  = "../../../modules/global/bastion"
  vpc_id  = module.vpc.vpc_id
  subnets = module.vpc.private_subnet_ids
}

module "efs" {
  source                   = "../../../modules/global/efs"
  vpc_id                   = module.vpc.vpc_id
  cluster_name             = var.cluster_name
  eks_worker_subnets       = module.vpc.private_subnet_ids
  worker_security_group_id = module.eks.worker_security_group_id
}

module "eks" {
  source             = "../../../modules/global/eks"
  cluster_name       = var.cluster_name
  instance_type      = var.instance_type
  vpc_id             = module.vpc.vpc_id
  eks_worker_subnets = module.vpc.private_subnet_ids
  eks_master_subnets = module.vpc.private_subnet_ids
  map_users          = var.map_users
}

module "helm_utility_applications" {
  source       = "../../../modules/global/helm"
  cluster_name = var.cluster_name
}
