output "worker_security_group_id" {
  value = module.eks.worker_security_group_id
}

output "cluster_id" {
  value = module.eks.cluster_id
}

output "oidc_url" {
  value = module.eks.cluster_oidc_issuer_url
}
