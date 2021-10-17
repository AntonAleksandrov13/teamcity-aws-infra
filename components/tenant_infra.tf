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
data "terraform_remote_state" "global_infra" {
  backend = "s3"

  config = {
    encrypt = true
    bucket  = var.terraform_bucket
    region  = var.region
    key     = "global_infra"
  }
}

module "rds" {
  source           = "../../../modules/shared/rds"
  tenant_name      = var.tenant_name
  vpc_id           = data.terraform_remote_state.global_infra.outputs.vpc_id
  eks_worker_sg_id = data.terraform_remote_state.global_infra.outputs.eks_worker_sg_id
  bastion_sg_id    = data.terraform_remote_state.global_infra.outputs.bastion_sg_id
  subnet_ids       = data.terraform_remote_state.global_infra.outputs.private_subnet_ids
}

module "s3" {
  source      = "../../../modules/shared/s3"
  tenant_name = var.tenant_name
}

module "iam" {
  source            = "../../../modules/shared/iam"
  tenant_name       = var.tenant_name
  tenant_namespace  = var.tenant_namespace
  tenant_bucket_arn = module.s3.bucket_arn
  oidc_url          = data.terraform_remote_state.global_infra.outputs.oidc_url
}
