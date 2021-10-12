module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "3.7.0"
  name = var.vpc_name
  cidr = var.cidr

  azs             = var.azs
  private_subnets = var.private_subnets
  public_subnets  = var.public_subnets

  enable_nat_gateway = var.enable_nat_gateway
  create_egress_only_igw= var.create_egress_only_igw
  enable_dns_hostnames = var.enable_dns_hostnames

  private_subnet_tags = var.private_subnet_tags

}