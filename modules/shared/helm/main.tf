locals {
  tenant_name  = replace(var.tenant_name, "/\\W|_|\\s/", "")
  service_name = "${local.tenant_name}-${var.service_suffix}"
  common_name  = "${local.tenant_name}.${var.hosted_zone}"
}
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
}
data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
      command     = "aws"
    }
  }
}

data "template_file" "tenant_teamcity_values" {
  template = file("../../../modules/shared/helm/teamcity-values.yaml.tpl")
  vars = {
    storage_class   = var.storage_class
    db_user         = var.db_user
    db_password     = var.db_password
    db_name         = var.db_name
    db_host         = var.db_host
    server_role_arn = var.server_role_arn
    agent_role_arn  = var.agent_role_arn
    service_name    = local.service_name
    bucket          = var.bucket
    prefix          = var.prefix
    common_name     = local.common_name
    distribution_id = var.cf_distribution_id
    pubkey_id       = var.cf_pubkey_id
    pk_pem          = var.cf_pk_pem #it's better to be separated into a set argument inside helm_release. due to path complexy - helm provider cannot see this variable
  }
}

resource "helm_release" "tenant-teamcity" {
  name             = local.tenant_name
  repository       = "https://antonaleksandrov13.github.io/teamcity-chart"
  chart            = "teamcity"
  version          = "0.7.0"
  namespace        = var.tenant_namespace
  create_namespace = true
  values = [
    data.template_file.tenant_teamcity_values.rendered
  ]
}


