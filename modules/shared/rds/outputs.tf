output "db_user" {
  value = module.db.db_instance_username
}
output "db_password" {
  value = module.db.db_master_password
}
output "db_name" {
  value = module.db.db_instance_name
}