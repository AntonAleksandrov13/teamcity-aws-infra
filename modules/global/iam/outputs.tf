output "cluster_autoscaler_role_arn" {
  value = module.cluster_autoscaler_role.iam_role_arn
}

output "external_dns_role_arn" {
  value = module.external_dns_role.iam_role_arn
}

output "aws_efs_csi_driver_role_arn" {
  value = module.aws_efs_csi_driver_role.iam_role_arn
}