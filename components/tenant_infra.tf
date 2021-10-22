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
#separation of tenant infra from global leads to the fact we either need to query remote outputs
#or use data resources. Quering remote state seems more reasonable to me here since I would have to ensure
#that proper tags in place before querying the data. With this setup, however you only need to be sure that your global infra is applied correctly
data "terraform_remote_state" "global_infra" {
  backend = "s3"

  config = {
    encrypt = true
    bucket  = var.terraform_bucket
    region  = var.region
    key     = "global_infra"
  }
}
locals {
  #cleaning up name of tenant name and namespace from any special symbols as some modules will not accept them
  tenant_name  = replace(var.tenant_name, "/\\W|_|\\s/", "")
  tenant_namespace = replace(var.tenant_namespace, "/\\W|_|\\s/", "")
}

module "rds" {
  source           = "../../../modules/shared/rds"
  tenant_name      = local.tenant_name
  vpc_id           = data.terraform_remote_state.global_infra.outputs.vpc_id
  eks_worker_sg_id = data.terraform_remote_state.global_infra.outputs.eks_worker_sg_id
  bastion_sg_id    = data.terraform_remote_state.global_infra.outputs.bastion_sg_id
  subnet_ids       = data.terraform_remote_state.global_infra.outputs.private_subnet_ids
}

module "s3" {
  source      = "../../../modules/shared/s3"
  tenant_name = local.tenant_name
  oai_arn     = data.terraform_remote_state.global_infra.outputs.oai_arn

}

module "cloudfront" {
  source                      = "../../../modules/shared/cloudfront"
  tenant_name                 = local.tenant_name
  oai_path                    = data.terraform_remote_state.global_infra.outputs.oai_path
  bucket_regional_domain_name = module.s3.bucket_regional_domain_name
}

module "iam" {
  source            = "../../../modules/shared/iam"
  tenant_name       = local.tenant_name
  tenant_namespace  = local.tenant_namespace
  tenant_bucket_arn = module.s3.bucket_arn
  oidc_url          = data.terraform_remote_state.global_infra.outputs.oidc_url
}

module "helm" {
  source             = "../../../modules/shared/helm"
  tenant_name        = local.tenant_name
  tenant_namespace   = local.tenant_namespace
  cluster_name       = data.terraform_remote_state.global_infra.outputs.cluster_name
  db_user            = module.rds.db_user
  db_password        = module.rds.db_password
  db_host            = module.rds.db_host
  db_name            = module.rds.db_name
  agent_role_arn     = module.iam.agent_role_arn
  server_role_arn    = module.iam.server_role_arn
  bucket             = module.s3.bucket_name
  cf_distribution_id = module.cloudfront.distribution_id
  cf_pubkey_id       = module.cloudfront.cf_pub_key_id
  cf_pk_pem          = module.cloudfront.cf_pk_pem
  hosted_zone = data.terraform_remote_state.global_infra.outputs.hosted_zone
}
