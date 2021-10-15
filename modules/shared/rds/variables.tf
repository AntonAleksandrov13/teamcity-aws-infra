variable "tenant_name" {
  type = string
}
variable "vpc_id" {
  type = string
}

variable "bastion_sg_id" {
  type = string
}

variable "eks_worker_sg_id" {
  type = string
}

variable "db_subnets" {
  type = string
}

variable "engine" {
  type    = string
  default = "mysql"
}

variable "engine_version" {
  type    = string
  default = "8.0.20"
}

variable "family" {
  type    = string
  default = "mysql8.0"
}

variable "major_engine_version" {
  type    = string
  default = "8.0"
}

variable "instance_class" {
  type    = string
  default = "db.t2.micro"
}

variable "allocated_storage" {
  type    = number
  default = 20
}

variable "max_allocated_storage" {
  type    = number
  default = 100
}

variable "storage_encrypted" {
  type    = bool
  default = true
}

variable "multi_az" {
  type    = bool
  default = true
}

variable "subnet_ids" {
  type = list(string)
}

variable "maintenance_window" {
  type    = string
  default = "Sun:00:00-Sun:03:00"
}

variable "backup_window" {
  type    = string
  default = "03:00-06:00"
}

variable "enabled_cloudwatch_logs_exports" {
  type    = list(string)
  default = ["general"]
}

variable "backup_retention_period" {
  type    = number
  default = 0
}

variable "skip_final_snapshot" {
  type    = bool
  default = true
}

variable "performance_insights_retention_period" {
  type    = number
  default = 7
}

variable "create_monitoring_role" {
  type    = bool
  default = true
}

variable "monitoring_interval" {
  type    = number
  default = 60
}

variable "parameters" {
  type = list(object({
    name  = string
    value = string
  }))
  default = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]
}




