
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
    "${file("${path.module}/nginx-ingress.yaml")}"
  ]
}
data "template_file" "aws_efs_csi_driver_values" {
  template = file("${path.module}/aws-efs-csi-driver.yaml.tpl")
  vars = {
    role_arn = var.aws_efs_csi_driver_role_arn
  }
}

resource "helm_release" "aws-efs-csi-driver" {
  name       = "aws-efs-csi-driver"
  repository = "https://kubernetes-sigs.github.io/aws-efs-csi-driver/"
  chart      = "aws-efs-csi-driver"
  version    = "2.2.0"
  namespace  = "kube-system"
  values = [
    data.template_file.aws_efs_csi_driver_values.rendered
  ]
}

data "template_file" "cluster_autoscaler_values" {
  template = file("${path.module}/cluster_autoscaler.yaml.tpl")
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
  template = file("${path.module}/external_dns.yaml.tpl")
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
  template = file("${path.module}/metrics_server.yaml.tpl")
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
  yaml_body = file("${path.module}/self-signed-issuer.yaml")
}

data "template_file" "efs_storage_class" {
  template = file("${path.module}/efs-storageclass.yaml.tpl")
  vars = {
    "fs_id" = var.efs_id
  }
}

resource "kubectl_manifest" "efs-storage-class" {
  provider  = kubectl
  yaml_body = data.template_file.efs_storage_class.rendered
}
