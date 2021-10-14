locals {
    name = "rds-${var.tenant_name}"
}

data "aws_vpc" "main" {
  id = var.vpc_id
}

data "aws_security_group" "eks_worker_sg_id" {
  name   = "default"
  vpc_id = data.aws_vpc.main.id
}

data "aws_security_group" "bastion_sg_id" {
  name   = "default"
  vpc_id = data.aws_vpc.main.id
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

  tags = local.tags
}

# module "db" {
#   source = "terraform-aws-modules/rds/aws"

#   identifier = local.db_name

#   engine               = "mysql"
#   engine_version       = "8.0.20"
#   family               = "mysql8.0" # DB parameter group
#   major_engine_version = "8.0"      # DB option group
#   instance_class       = "db.t3.large"

#   allocated_storage     = 20
#   max_allocated_storage = 100
#   storage_encrypted     = false

#   name     = "completeMysql"
#   username = "complete_mysql"
#   password = "YourPwdShouldBeLongAndSecure!"
#   port     = 3306

#   multi_az               = true
#   subnet_ids             = module.vpc.database_subnets
#   vpc_security_group_ids = [module.security_group.security_group_id]

#   maintenance_window              = "Mon:00:00-Mon:03:00"
#   backup_window                   = "03:00-06:00"
#   enabled_cloudwatch_logs_exports = ["general"]

#   backup_retention_period = 0
#   skip_final_snapshot     = true
#   deletion_protection     = false

#   performance_insights_enabled          = true
#   performance_insights_retention_period = 7
#   create_monitoring_role                = true
#   monitoring_interval                   = 60

#   parameters = [
#     {
#       name  = "character_set_client"
#       value = "utf8mb4"
#     },
#     {
#       name  = "character_set_server"
#       value = "utf8mb4"
#     }
#   ]

#   tags = local.tags
#   db_instance_tags = {
#     "Sensitive" = "high"
#   }
#   db_option_group_tags = {
#     "Sensitive" = "low"
#   }
#   db_parameter_group_tags = {
#     "Sensitive" = "low"
#   }
#   db_subnet_group_tags = {
#     "Sensitive" = "high"
#   }
# }