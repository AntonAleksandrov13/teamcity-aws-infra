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

module "eks" {
  source                      = "../../../modules/global/eks"
  cluster_name                = var.cluster_name
  instance_type               = var.instance_type
  desired_eks_workers_per_asg = var.desired_eks_workers_per_asg
  min_eks_workers_per_asg     = var.min_eks_workers_per_asg
  vpc_id                      = module.vpc.vpc_id
  eks_worker_subnets          = module.vpc.private_subnet_ids
  eks_master_subnets          = module.vpc.private_subnet_ids
  map_users                   = var.map_users
}

module "efs" {
  source                   = "../../../modules/global/efs"
  vpc_id                   = module.vpc.vpc_id
  cluster_name             = module.eks.cluster_id
  eks_worker_subnets       = module.vpc.private_subnet_ids
  worker_security_group_id = module.eks.worker_security_group_id
}

module "iam" {
  source   = "../../../modules/global/iam"
  oidc_url = module.eks.oidc_url
}

module "helm_utility_applications" {
  source                      = "../../../modules/global/helm"
  cluster_name                = module.eks.cluster_id
  region                      = var.region
  efs_id                      = module.efs.id
  cluster_autoscaler_role_arn = module.iam.cluster_autoscaler_role_arn
  external_dns_role_arn       = module.iam.external_dns_role_arn
  aws_efs_csi_driver_role_arn = module.iam.aws_efs_csi_driver_role_arn
  txt_owner_id                = module.route53.txt_owner_id
}

module "cloudfront" {
  source = "../../../modules/global/cloudfront"
}
output "vpc_id" {
  value = module.vpc.vpc_id
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "eks_worker_sg_id" {
  value = module.eks.worker_security_group_id
}

output "bastion_sg_id" {
  value = module.bastion.bastion_sg_id
}

output "oidc_url" {
  value = module.eks.oidc_url
}

output "cluster_name" {
  value = var.cluster_name
}

output "oai_arn" {
  value = module.cloudfront.oai_arn
}
output "oai_path" {
  value = module.cloudfront.oai_path
}
