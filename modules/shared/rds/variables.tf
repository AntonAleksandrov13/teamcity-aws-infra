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

variable "engine" {
    type = string
    default = "mysql"
}

variable "engine_version" {
  type =string
  default = "8.0.20"
}

variable "family" {
    type=string
    default = "mysql8.0"
}

variable "major_engine_version" {
    type=string
    default = "8.0"
}

variable "instance_type" {
    type =string
    default = "db.t2.micro"
}




