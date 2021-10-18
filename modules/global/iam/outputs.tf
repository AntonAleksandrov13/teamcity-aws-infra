output "cluster_autoscaler_role_arn" {
  value = module.cluster-autoscaler-role.iam_role_arn
}

output "external_dns_role_arn" {
  value = module.external-dns-role.iam_role_arn
}

output "aws-efs-csi-driver-role" {
  value = module.aws-efs-csi-role.iam_role_arn
}