locals {
  name = "rds-${var.tenant_name}"
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4"

  name        = local.name
  description = "RDS security group for ${var.tenant_name}"
  vpc_id      = var.vpc_id

  # ingress
  ingress_with_source_security_group_id = [
    {
      rule                     = "mysql-tcp"
      source_security_group_id = var.eks_worker_sg_id
    },
    {
      rule                     = "mysql-tcp"
      source_security_group_id = var.bastion_sg_id
    },

  ]
}
resource "random_password" "password" {
  length           = 16
  special          = true
  override_special = "_%@"
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = local.name


  engine               = var.engine
  engine_version       = var.engine_version
  family               = var.family               # DB parameter group
  major_engine_version = var.major_engine_version # DB option group
  instance_class       = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = var.storage_encrypted

  name     = local.name
  username = local.name
  password = random_password.password.result
  port     = 3306

  multi_az               = var.multi_az
  subnet_ids             = var.db_subnets
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = var.maintenance_window
  backup_window                   = var.backup_window
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  create_monitoring_role                = var.create_monitoring_role
  monitoring_interval                   = var.monitoring_interval

  parameters = var.parameters
}