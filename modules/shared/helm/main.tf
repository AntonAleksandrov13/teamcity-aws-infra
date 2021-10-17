locals {
  tenant_name  = replace(var.tenant_name, "/\\W|_|\\s/", "")
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

resource "helm_release" "tenant-teamcity" {
  name       = "tenant-teamcity"
  repository = "https://antonaleksandrov13.github.io/teamcity-chart"
  chart      = "teamcity"
  version    = "0.5.0"
  namespace  = local.tenant_name
  values = [
    "${file("../../../modules/shared/helm/teamcity-values.yaml.tpl")}"
  ]
}


