locals {
  #t2... instances cannot enable at rest encryption or performance insightsname
  #if instance contains t2... we disable these properties, else variable with the default value is used
  is_t2_instance_class         = length(regexall(".t2.", var.instance_class)) > 0
  storage_encrypted            = local.is_t2_instance_class ? false : var.storage_encrypted
  performance_insights_enabled = local.is_t2_instance_class ? false : var.performance_insights_enabled
}

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 4"

  name        = var.tenant_name
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
  length  = 32
  special = false
}

module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.tenant_name


  engine               = var.engine
  engine_version       = var.engine_version
  family               = var.family               # DB parameter group
  major_engine_version = var.major_engine_version # DB option group
  instance_class       = var.instance_class

  allocated_storage     = var.allocated_storage
  max_allocated_storage = var.max_allocated_storage
  storage_encrypted     = local.storage_encrypted

  name     = var.tenant_name
  username = var.tenant_name
  password = random_password.password.result
  port     = 3306

  multi_az               = var.multi_az
  subnet_ids             = var.subnet_ids
  vpc_security_group_ids = [module.security_group.security_group_id]

  maintenance_window              = var.maintenance_window
  backup_window                   = var.backup_window
  enabled_cloudwatch_logs_exports = var.enabled_cloudwatch_logs_exports

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot
  deletion_protection     = var.deletion_protection

  performance_insights_enabled          = local.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_retention_period
  create_monitoring_role                = var.create_monitoring_role
  monitoring_interval                   = var.monitoring_interval

  parameters = var.parameters
}
