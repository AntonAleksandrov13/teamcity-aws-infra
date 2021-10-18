output "server_role_arn" {
  value = module.tenant-server-role.iam_role_arn
}
output "agent_role_arn" {
  value = module.tenant-agent-role.iam_role_arn
}
