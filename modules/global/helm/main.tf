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
