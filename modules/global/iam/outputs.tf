output "cluster_autoscaler_role_arn" {
  value = module.cluster-autoscaler-role.iam_role_arn
}

output "external-dns_role_arn" {
  value = module.external-dns-role.iam_role_arn
}
