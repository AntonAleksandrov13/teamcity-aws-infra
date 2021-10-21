output "bastion_sg_id" {
  value = module.ec2_bastion_server.security_group_id
}