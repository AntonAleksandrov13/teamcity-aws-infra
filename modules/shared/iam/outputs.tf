output "server_role_arn" {
  value = module.tenant_server_role.iam_role_arn
}
output "agent_role_arn" {
  value = module.tenant_agent_role.iam_role_arn
}
