output "server_role_arn" {
  value = module.server-agent-role.iam_role_name
}
output "agent_role_arn" {
  value = module.tenant-agent-role.iam_role_name
}
