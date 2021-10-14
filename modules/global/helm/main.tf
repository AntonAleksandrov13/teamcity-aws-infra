
terraform {
  required_version = ">= 1.0.0"

  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
  }
  backend "s3" {
    key = "helm"
  }
}
data "aws_eks_cluster" "eks" {
  name = var.cluster_name
}

data "aws_eks_cluster_auth" "eks" {
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
provider "kubectl" {
  apply_retry_count      = 15
  host                   = data.aws_eks_cluster.eks.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks.certificate_authority[0].data)
  load_config_file       = false
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", var.cluster_name]
    command     = "aws"
  }
}

resource "helm_release" "nginx-ingress" {
  name       = "ingress-nginx"
  repository = "https://kubernetes.github.io/ingress-nginx"
  chart      = "ingress-nginx"
  version    = "4.0.5"
  namespace  = "kube-system"
  values = [
    "${file("../../../modules/global/helm/nginx-ingress.yaml")}"
  ]
}

resource "helm_release" "efs-provisioner" {
  name       = "efs-provisioner"
  repository = "https://charts.helm.sh/stable"
  chart      = "efs-provisioner"
  version    = "0.13.2"
  namespace  = "kube-system"

  set {
    name  = "efsProvisioner.efsFileSystemId"
    value = var.efs_id
  }
  set {
    name  = "efsProvisioner.awsRegion"
    value = var.region
  }
  set {
    name  = "efsProvisioner.provisionerName"
    value = var.provisioner_name
  }
  set {
    name  = "efsProvisioner.storageClass.name"
    value = var.storage_class_name
  }
}

data "template_file" "cluster_autoscaler_values" {
  template = file("../../../modules/global/helm/cluster_autoscaler.yaml.tpl")
  vars = {
    cluster_name = var.cluster_name
    region       = var.region
    role_arn     = var.cluster_autoscaler_role_arn
  }
}

resource "helm_release" "cluster-autoscaler" {
  name       = "cluster-autoscaler"
  repository = "https://kubernetes.github.io/autoscaler"
  chart      = "cluster-autoscaler"
  version    = "9.9.2"
  namespace  = "kube-system"

  values = [
    data.template_file.cluster_autoscaler_values.rendered
  ]
}

data "template_file" "external_dns_values" {
  template = file("../../../modules/global/helm/external_dns.yaml.tpl")
  vars = {
    region       = var.region
    role_arn     = var.external_dns_role_arn
    txt_owner_id = var.txt_owner_id
  }
}

resource "helm_release" "external-dns" {
  name       = "external-dns"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = "4.4.3"
  namespace  = "kube-system"

  values = [
    data.template_file.external_dns_values.rendered
  ]
}

resource "helm_release" "cert-manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "1.4.1"
  namespace  = "kube-system"

  set {
    name  = "installCRDs"
    value = true
  }
}

data "template_file" "metrics_server_values" {
  template = file("../../../modules/global/helm/metrics_server.yaml.tpl")
}

resource "helm_release" "metrics-server" {
  name       = "metrics-server"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "metrics-server"
  version    = "5.10.3"
  namespace  = "kube-system"

  values = [
    data.template_file.metrics_server_values.rendered
  ]
}

resource "kubectl_manifest" "cluster-issuer" {
  provider  = kubectl
  yaml_body = file("../../../modules/global/helm/self-signed-issuer.yaml")
}
