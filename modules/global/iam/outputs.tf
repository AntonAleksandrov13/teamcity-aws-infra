output "cluster_autoscaler_role_arn" {
  value = module.cluster-autoscaler-role.iam_role_arn
}

output "external_dns_role_arn" {
  value = module.external-dns-role.iam_role_arn
}

output "aws_efs_csi_driver_role_arn" {
  value = module.aws-efs-csi-driver-role.iam_role_arn
}